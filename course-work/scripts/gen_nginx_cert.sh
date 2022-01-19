#!/usr/bin/env bash

export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_TOKEN=s.gtFWQnJh4C7ZpDLeK9d2RG6A

vault write -format=json pki_int/issue/test-dot-local \
    common_name=testsrv.test.local  ttl="720h" > testsrv.test.local.crt.file

cat testsrv.test.local.crt.file | jq -r .data.certificate > /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.issuing_ca >> /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.private_key > /etc/nginx/ssl/testsrv.test.local.key

systemctl restart nginx.service
