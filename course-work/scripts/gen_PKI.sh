#!/usr/bin/env bash

set -o xtrace
export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_TOKEN=s.gtFWQnJh4C7ZpDLeK9d2RG6A

# Активация возможности работы с pki, для корневого центра сертификации
vault secrets enable pki

# Установка ttl по умолчанию
vault secrets tune -max-lease-ttl=87600h pki

# Генерация корневого сертификата (Root CA)
vault write -format=json pki/root/generate/internal \
common_name="test.local" ttl=8760h  > pki-ca-root.json

# Сохранение корневого сертификата в отдельный файл
cat pki-ca-root.json | jq -r .data.certificate > CA_cert.crt

# Конфигурация URLs для корневого центра сертификации
vault write pki/config/urls \
        issuing_certificates="https://127.0.0.1:8200/v1/pki/ca" \
        crl_distribution_points="https://127.0.0.1:8200/v1/pki/crl"

###################################################################################

# Активация возможности работы с pki, для промежуточного центра сертификации
vault secrets enable -path=pki_int pki

# Установка ttl по умолчанию
vault secrets tune -max-lease-ttl=43800h pki_int

# Генерация сертификата для промежуточного центра сертификации и создание запроса Certificate Signing Request
vault write -format=json pki_int/intermediate/generate/internal \
        common_name="test.local Intermediate Authority" \
        | jq -r '.data.csr' > pki_intermediate.csr

# Процедура подписи сертификата промежуточного центра сертификации корневым CA
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
        format=pem_bundle ttl="43800h" \
        | jq -r '.data.certificate' > intermediate.cert.pem


# Сохранение подписанного сертификата промежуточного центра сертификации
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

# Конфигурация URLs для промежуточного центра сертификации
vault write pki_int/config/urls \
     issuing_certificates="https://127.0.0.1:8200/v1/pki_int/ca" \
     crl_distribution_points="https://127.0.0.1:8200/v1/pki_int/crl"

############################################################################################

# Создание роли для генерации сертификатов для хостов (будут использоваться в nginx)
vault write pki_int/roles/test-dot-local \
        allowed_domains="test.local" \
        allow_subdomains=true \
        max_ttl="8760h"

#############################################################################################

# Генерация нового сертификата
vault write -format=json pki_int/issue/test-dot-local \
    common_name=testsrv.test.local  ttl="720h" > testsrv.test.local.crt.file

# Сохранение сертификата и ключа в отдельные файлы, расположенные в директориях, которые будут использоваться в конфиге nginx
cat testsrv.test.local.crt.file | jq -r .data.certificate > /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.issuing_ca >> /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.private_key > /etc/nginx/ssl/testsrv.test.local.key

#############################################################################################
