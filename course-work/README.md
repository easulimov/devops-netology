# Курсовая работа по итогам модуля "DevOps и системное администрирование"

Курсовая работа необходима для проверки практических навыков, полученных в ходе прохождения курса "DevOps и системное администрирование".

Мы создадим и настроим виртуальное рабочее место. Позже вы сможете использовать эту систему для выполнения домашних заданий по курсу

## Задание

1. Создайте виртуальную машину Linux.
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
6. Установите nginx.
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

## Результат

Результатом курсовой работы должны быть снимки экрана или текст:

- Процесс установки и настройки ufw
- Процесс установки и выпуска сертификата с помощью hashicorp vault
- Процесс установки и настройки сервера nginx
- Страница сервера nginx в браузере хоста не содержит предупреждений 
- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")
- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)


######################################################################################
######################################################################################

1. Создайте виртуальную машину Linux.

### Решение:
```bash
gendalf@pc01:~$ mkdir course-work
gendalf@pc01:~$ cd course-work/
gendalf@pc01:~/course-work$ vim Vagrantfile 
gendalf@pc01:~/course-work$ cat Vagrantfile 
 Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
            v.name = "testsrv"
        end
        config.vm.network "forwarded_port", guest: 443, host: 4443
 end
gendalf@pc01:~/course-work$ vagrant init
...
gendalf@pc01:~/course-work$ vagrant up
...
gendalf@pc01:~/course-work$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun 09 Jan 2022 12:28:45 PM UTC

  System load:  0.02               Processes:             130
  Usage of /:   11.6% of 30.88GB   Users logged in:       0
  Memory usage: 10%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
vagrant@vagrant:~$ 
vagrant@vagrant:~$ sudo -i
root@vagrant:~# apt update
...
...
Reading state information... Done
14 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@vagrant:~# 
root@vagrant:~# apt install -y wget curl jq
Reading package lists... Done
...
...
root@vagrant:~# which jq && which curl && which wget
/usr/bin/jq
/usr/bin/curl
/usr/bin/wget
root@vagrant:~# 
root@vagrant:~# vim /etc/hosts
127.0.0.1 testsrv.test.local testsrv localhost


# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
root@vagrant:~# 
root@vagrant:~# hostnamectl set-hostname testsrv
root@vagrant:~# hostnamectl
   Static hostname: testsrv
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 1929d6537abe4ead8816d28b18da5905
           Boot ID: 299bf1058a50490499bca295c128da49
    Virtualization: oracle
  Operating System: Ubuntu 20.04.3 LTS
            Kernel: Linux 5.4.0-91-generic
      Architecture: x86-64
root@vagrant:~# 
root@vagrant:~# exit
logout
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.
gendalf@pc01:~/course-work$ vagrant ssh
...
```


######################################################################################
######################################################################################


2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.

### Решение:
*  Настройка ufw
```
vagrant@testsrv:~$ sudo -i
root@testsrv:~# ufw status
Status: inactive
root@testsrv:~# 
root@testsrv:~# ufw allow from 127.0.0.0/8
Rules updated
root@testsrv:~# ufw allow 22/tcp
Rules updated
Rules updated (v6)
root@testsrv:~# ufw allow 443/tcp
Rules updated
Rules updated (v6)
root@testsrv:~# ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
root@testsrv:~# 
root@testsrv:~# 
root@testsrv:~# ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
root@testsrv:~# 
root@testsrv:~# 
root@testsrv:~# 
root@testsrv:~# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
root@testsrv:~# 
root@testsrv:~# ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
Anywhere                   ALLOW IN    127.0.0.0/8               
22/tcp                     ALLOW IN    Anywhere                  
443/tcp                    ALLOW IN    Anywhere                  
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
443/tcp (v6)               ALLOW IN    Anywhere (v6)             

root@testsrv:~# 

```

######################################################################################
######################################################################################


3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).

### Решение:
* Установка Vault
```
root@testsrv:~# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
root@testsrv:~# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
...
...
...
The following NEW packages will be installed:
  vault
0 upgraded, 1 newly installed, 0 to remove and 14 not upgraded.
Need to get 69.4 MB of archives.
After this operation, 188 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.2 [69.4 MB]
Fetched 69.4 MB in 10s (6,804 kB/s)                                           
Selecting previously unselected package vault.
(Reading database ... 40637 files and directories currently installed.)
Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...
Unpacking vault (1.9.2) ...
Setting up vault (1.9.2) ...
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
...................................................................................................................................................................................................................................................................++++
................................................................................++++
writing new private key to 'tls.key'
-----
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
root@testsrv:~# 
root@testsrv:~# vault --version
Vault v1.9.2 (f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf)
root@testsrv:~# 

```

* Настройка самоподписного сертификата для Vault (для использования TLS)
```
root@testsrv:/opt/vault/tls# vim /tmp/san.cnf
root@testsrv:/opt/vault/tls# cat /tmp/san.cnf
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = RU
ST = Moscow
L = Moscow
CN = Vault
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = testsrv
DNS.3 = testsrv.test.local
IP.1 = 127.0.0.1
root@testsrv:/opt/vault/tls# 
root@testsrv:/opt/vault/tls# 
root@testsrv:/opt/vault/tls# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /opt/vault/tls/selfsigned.key -out /opt/vault/tls/selfsigned.crt -config /tmp/san.cnf
Generating a RSA private key
...............................................+++++
..............................................................+++++
writing new private key to '/opt/vault/tls/selfsigned.key'
-----
root@testsrv:/opt/vault/tls#
root@testsrv:/opt/vault/tls#
root@testsrv:/opt/vault/tls# ll
total 24
drwx------ 2 vault vault 4096 Jan 19 09:49 ./
drwxr-xr-x 4 vault vault 4096 Jan 19 09:39 ../
-rw-r--r-- 1 root  root  1245 Jan 19 09:49 selfsigned.crt
-rw------- 1 root  root  1704 Jan 19 09:49 selfsigned.key
-rw------- 1 vault vault 1850 Jan 19 09:39 tls.crt
-rw------- 1 vault vault 3272 Jan 19 09:39 tls.key
root@testsrv:/opt/vault/tls# 
root@testsrv:/opt/vault/tls# 
root@testsrv:/opt/vault/tls# chown vault:vault selfsigned.*
root@testsrv:/opt/vault/tls# ll selfsigned.*
-rw-r--r-- 1 vault vault 1245 Jan 19 09:49 selfsigned.crt
-rw------- 1 vault vault 1704 Jan 19 09:49 selfsigned.key
root@testsrv:/opt/vault/tls# 
```

* Для успешной работы службы vault, ранее созданный самоподписной сертификат selfsigned.crt требуется зарегистрировать в хранилище сертификатов ОС
```
root@testsrv:/opt/vault/tls# cp selfsigned.crt /usr/local/share/ca-certificates/
root@testsrv:/opt/vault/tls# ls -la /usr/local/share/ca-certificates/
total 12
drwxr-xr-x 2 root root 4096 Jan 19 10:05 .
drwxr-xr-x 4 root root 4096 Aug 24 08:43 ..
-rw-r--r-- 1 root root 1245 Jan 19 10:05 selfsigned.crt
root@testsrv:/opt/vault/tls# update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
root@testsrv:/opt/vault/tls# 
```

* Настройка файла конфигурации vault.hcl для работы по https
```
root@testsrv:/opt/vault/tls# cd /etc/vault.d/
root@testsrv:/etc/vault.d# vim vault.hcl 
root@testsrv:/etc/vault.d# cat vault.hcl 
ui = true


storage "file" {
  path = "/opt/vault/data"
}

# HTTP listener
#listener "tcp" {
#  address = "127.0.0.1:8200"
#  tls_disable = 1
#}

# HTTPS listener
listener "tcp" {
  address       = "127.0.0.1:8200"
  tls_cert_file = "/opt/vault/tls/selfsigned.crt"
  tls_key_file  = "/opt/vault/tls/selfsigned.key"
}

api_addr = "https://127.0.0.1:8200"

root@testsrv:/etc/vault.d# 
root@testsrv:/etc/vault.d# 
```

* Экспорт переменной VAULT_ADDR и запуск службы vault.service
```
root@testsrv:/etc/vault.d# export VAULT_ADDR=https://127.0.0.1:8200
root@testsrv:/etc/vault.d# vim /etc/environment 
root@testsrv:/etc/vault.d# cat /etc/environment 
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
export VAULT_ADDR=https://127.0.0.1:8200
root@testsrv:/etc/vault.d# 
root@testsrv:/etc/vault.d# 
root@testsrv:/etc/vault.d# systemctl enable vault --now
root@testsrv:/etc/vault.d# systemctl enable vault --now
Created symlink /etc/systemd/system/multi-user.target.wants/vault.service → /lib/systemd/system/vault.service.
root@testsrv:/etc/vault.d# 
root@testsrv:/etc/vault.d# systemctl status vault --now
● vault.service - "HashiCorp Vault - A tool for managing secrets"
     Loaded: loaded (/lib/systemd/system/vault.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-01-19 10:11:43 UTC; 11s ago
       Docs: https://www.vaultproject.io/docs/
   Main PID: 16942 (vault)
      Tasks: 9 (limit: 2279)
     Memory: 58.3M
     CGroup: /system.slice/vault.service
             └─16942 /usr/bin/vault server -config=/etc/vault.d/vault.hcl

Jan 19 10:11:43 testsrv vault[16942]:               Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "enabled")
Jan 19 10:11:43 testsrv vault[16942]:                Log Level: info
Jan 19 10:11:43 testsrv vault[16942]:                    Mlock: supported: true, enabled: true
Jan 19 10:11:43 testsrv vault[16942]:            Recovery Mode: false
Jan 19 10:11:43 testsrv vault[16942]:                  Storage: file
Jan 19 10:11:43 testsrv vault[16942]:                  Version: Vault v1.9.2
Jan 19 10:11:43 testsrv vault[16942]:              Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf
Jan 19 10:11:43 testsrv vault[16942]: ==> Vault server started! Log data will stream in below:
Jan 19 10:11:43 testsrv vault[16942]: 2022-01-19T10:11:43.159Z [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no_proxy="\"\""
Jan 19 10:11:43 testsrv vault[16942]: 2022-01-19T10:11:43.177Z [INFO]  core: Initializing VersionTimestamps for core
root@testsrv:/etc/vault.d# 
```

* Проверка статуса vault
```
root@testsrv:/etc/vault.d# vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.9.2
Storage Type       file
HA Enabled         false
root@testsrv:/etc/vault.d# 
```

* Настройка vault autocomplete - для удобства работы в CLI (предложение вариантов ввода команд, при двойном нажатии TAB)
```
vault -autocomplete-install && source $HOME/.bashrc
```

* Инициализация vault. 
```
root@testsrv:/etc/vault.d# vault operator init
Unseal Key 1: SEaP/IfYagOXifM4uyLS02cPNPK+dMCqMVSqZGZHrf5M
Unseal Key 2: faMv5nl1Ckz+XZuj0qRw5ppP3PHlWmuWy0WeAYrGOwIo
Unseal Key 3: xZ0PjtPwcTay/Kw0pnOKwCrJCij4v2zDnHHhTyfq3EWu
Unseal Key 4: pIqsrs2PaTQSuvsFH0r4OotGLoApU5dI4DIF5yWPNMTU
Unseal Key 5: kW8MtDMiCXt7bpOedsxaD3YGxoNyfTx0GiMxgskOojiw

Initial Root Token: s.gtFWQnJh4C7ZpDLeK9d2RG6A

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 keys to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
root@testsrv:/etc/vault.d# 
```

* Распечатка vault. Используем любые 3 ключа из 5 ранее выпущенных.
```
root@testsrv:/etc/vault.d# vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    0/3
Unseal Nonce       n/a
Version            1.9.2
Storage Type       file
HA Enabled         false
root@testsrv:/etc/vault.d# 
root@testsrv:/etc/vault.d# vault operator unseal 
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       ba2d9e57-a2e9-5287-a639-4ff442a527d9
Version            1.9.2
Storage Type       file
HA Enabled         false
root@testsrv:/etc/vault.d# vault operator unseal 
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       ba2d9e57-a2e9-5287-a639-4ff442a527d9
Version            1.9.2
Storage Type       file
HA Enabled         false
root@testsrv:/etc/vault.d# vault operator unseal 
Unseal Key (will be hidden): 
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.9.2
Storage Type    file
Cluster Name    vault-cluster-dd3e6cdf
Cluster ID      6464495e-a516-421d-a294-795df5563b18
HA Enabled      false
root@testsrv:/etc/vault.d# 
```

######################################################################################
######################################################################################


4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).

### Решение:
* Выполним логин с использованием ранее полученного root токена
```
root@testsrv:/etc/vault.d# vault login 
Token (will be hidden): 
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.gtFWQnJh4C7ZpDLeK9d2RG6A
token_accessor       vn4Ud9Ku3LAvdLHrXsimb7hI
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
root@testsrv:/etc/vault.d# 
```

* Подготовка директорий
```
root@testsrv:~# mkdir test.local.CA
root@testsrv:~# mkdir -p /etc/nginx/ssl/
```

* Подготовка скрипта с командами создания центра сертификации
```
root@testsrv:~# cd test.local.CA
root@testsrv:~/test.local.PKI# vim gen_PKI.sh
root@testsrv:~/test.local.PKI# chmod +x gen_PKI.sh
```

* Содержимое `gen_PKI.sh`
```bash
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

# Создание роли для генерации сертификатов для хостов (будут использоваться в nginx)
cat testsrv.test.local.crt.file | jq -r .data.certificate > /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.issuing_ca >> /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.private_key > /etc/nginx/ssl/testsrv.test.local.key

#############################################################################################
```

* Запускаем скрипт 
```
root@testsrv:~/test.local.PKI# ./gen_PKI.sh 
+ export VAULT_ADDR=https://127.0.0.1:8200
+ VAULT_ADDR=https://127.0.0.1:8200
+ export VAULT_TOKEN=s.gtFWQnJh4C7ZpDLeK9d2RG6A
+ VAULT_TOKEN=s.gtFWQnJh4C7ZpDLeK9d2RG6A
+ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
+ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
+ vault write -format=json pki/root/generate/internal common_name=test.local ttl=8760h
+ cat pki-ca-root.json
+ jq -r .data.certificate
+ vault write pki/config/urls issuing_certificates=https://127.0.0.1:8200/v1/pki/ca crl_distribution_points=https://127.0.0.1:8200/v1/pki/crl
Success! Data written to: pki/config/urls
+ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
+ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
+ vault write -format=json pki_int/intermediate/generate/internal 'common_name=test.local Intermediate Authority'
+ jq -r .data.csr
+ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl=43800h
+ jq -r .data.certificate
+ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
+ vault write pki_int/config/urls issuing_certificates=https://127.0.0.1:8200/v1/pki_int/ca crl_distribution_points=https://127.0.0.1:8200/v1/pki_int/crl
Success! Data written to: pki_int/config/urls
+ vault write pki_int/roles/test-dot-local allowed_domains=test.local allow_subdomains=true max_ttl=8760h
Success! Data written to: pki_int/roles/test-dot-local
+ vault write -format=json pki_int/issue/test-dot-local common_name=testsrv.test.local ttl=720h
+ cat testsrv.test.local.crt.file
+ jq -r .data.certificate
+ cat testsrv.test.local.crt.file
+ jq -r .data.issuing_ca
+ cat testsrv.test.local.crt.file
+ jq -r .data.private_key
root@testsrv:~/test.local.PKI#
```

* Проверка результатов выполнения команд в скрипте
```
root@testsrv:~/test.local.PKI# ll
total 36
drwxr-xr-x 2 root root 4096 Jan 19 11:37 ./
drwx------ 6 root root 4096 Jan 19 11:29 ../
-rw-r--r-- 1 root root 1168 Jan 19 11:37 CA_cert.crt
-rwxr-xr-x 1 root root 3804 Jan 19 11:18 gen_PKI.sh*
-rw-r--r-- 1 root root 1326 Jan 19 11:37 intermediate.cert.pem
-rw-r--r-- 1 root root 2689 Jan 19 11:37 pki-ca-root.json
-rw-r--r-- 1 root root  924 Jan 19 11:37 pki_intermediate.csr
-rw-r--r-- 1 root root 6233 Jan 19 11:37 testsrv.test.local.crt.file
root@testsrv:~/test.local.PKI# ll /etc/nginx/ssl/
total 16
drwxr-xr-x 2 root root 4096 Jan 19 11:30 ./
drwxr-xr-x 3 root root 4096 Jan 19 11:23 ../
-rw-r--r-- 1 root root 2737 Jan 19 11:37 testsrv.test.local.crt
-rw-r--r-- 1 root root 1679 Jan 19 11:37 testsrv.test.local.key
root@testsrv:~/test.local.PKI# cat CA_cert.crt 
-----BEGIN CERTIFICATE-----
MIIDMjCCAhqgAwIBAgIUfUcPDJkB2Oc8G4aXzRS6VIM6NYkwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKdGVzdC5sb2NhbDAeFw0yMjAxMTkxMTM2NTNaFw0yMzAx
MTkxMTM3MjNaMBUxEzARBgNVBAMTCnRlc3QubG9jYWwwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQChi0q2z5zbflZZsY8l/u3i5+PSIm91tByRiu/fwG0/
80VPcF/3kBHX2U2uy7pIngxW3AAaD7WeIOjU3dEXBXAX/Gele8KqLcDKOEBV2NWr
swT0tcM5X6HJjhkApcFY4eE99Nvgj6QuTCgYLrZHeT5CUe3NN+iu9ZXziHa5iE1t
7DBaau+PCoSUZZ4AoGGGnHRAafiCnkAQzaD09iDisD/Q7KROy099Yd30cB2tvmUb
eXWbrXbqS0n9Ga4/mQTg4VhZQUoB8SOryQwtC7Wnpfk/fh+KSz19sLzRxMVebA7r
tLPI6FA/Ay4mPyviEMn53BijUgAvq5sEGRHMQ8/By0QTAgMBAAGjejB4MA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSrNWl2kSIXu3Pw
ue6Ak+V4CcI4mjAfBgNVHSMEGDAWgBSrNWl2kSIXu3Pwue6Ak+V4CcI4mjAVBgNV
HREEDjAMggp0ZXN0LmxvY2FsMA0GCSqGSIb3DQEBCwUAA4IBAQCW3vPrOW7fc+AJ
Su2vIWZRjUmU22bPqRlKypJbi2OGseRmhn7eQgkuUqygz2eSZjqlyNl8PR8rANMO
n+5U19CM+BKQIUOXVrq/A+0IP+NyvtB2j2eB0l8fjuQkpZx9GW+arieHE2ZFQSiB
71b2c7YBCV6eKKYt72G3LUSPiHgJWmjQGk1CU6rs2KgJEUMOQgqEL1vB3lBV3dBe
DIJQjgOlQ3+UoaWEUbNVtg8aGA8PZgATIoTr4r1iXtSBJQ3IdT6u3vtMVTtPAt7W
7ErfqzVDByIijiKD071d5RkLDf3zJL7pFGIuKXjAbig1v3SfLt8Ek5QliNP6KdCV
CqEbiGEc
-----END CERTIFICATE-----
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# cat /etc/nginx/ssl/testsrv.test.local.crt 
-----BEGIN CERTIFICATE-----
MIID5TCCAs2gAwIBAgIUYnINlsBUmgJb/L+PGbnUHSWZNv4wDQYJKoZIhvcNAQEL
BQAwLDEqMCgGA1UEAxMhdGVzdC5sb2NhbCBJbnRlcm1lZGlhdGUgQXV0aG9yaXR5
MB4XDTIyMDExOTExMzY1NFoXDTIyMDIxODExMzcyNFowHTEbMBkGA1UEAxMSdGVz
dHNydi50ZXN0LmxvY2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
ztEAmS1GJGrsiDLSgd9RFd+ht/6YPbhNWh4OznAiilvqEvSLtzSqIgWm3SUG+bZc
1WDmDF7/SY/yAbsHsDIqicNCUritwzzc31Y23cEf8tAlz5IP1ZijcZs/bn/8d9Eb
sftW2hRNmnRAcnO2S53DnpLYVT65bQ5kKLZ/2lHW1xsRHt8n/rlDTGBJA22YwVk3
CAfVD6dSiFSLZSrZ4lG6A6paxkHTrBuiWwpioN9IN3OW9Kpk9w2VkuWBOxLHzKio
MlTW8MvInhC09nkKV67cXn/A4KzjFOFzbG3mZzd1KMpnQPPp78MPXZ+nQH/aBmZv
qgMsqCJN6YMlefIDt0WFGwIDAQABo4IBDDCCAQgwDgYDVR0PAQH/BAQDAgOoMB0G
A1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHQ4EFgQU7pCWotTK+HYl
LC/aZkeomtBFRqUwHwYDVR0jBBgwFoAU4Sra/jGVcZDTX5GjDWnm9MugaAcwQAYI
KwYBBQUHAQEENDAyMDAGCCsGAQUFBzAChiRodHRwczovLzEyNy4wLjAuMTo4MjAw
L3YxL3BraV9pbnQvY2EwHQYDVR0RBBYwFIISdGVzdHNydi50ZXN0LmxvY2FsMDYG
A1UdHwQvMC0wK6ApoCeGJWh0dHBzOi8vMTI3LjAuMC4xOjgyMDAvdjEvcGtpX2lu
dC9jcmwwDQYJKoZIhvcNAQELBQADggEBAJ/LJEqbpwODoxwMz0DMo+onoFG9dUVP
CxCezOaY7IROUFemCO0KugC2HhSNYiWYW+SxdQLkVdVwSCNKEb0Eao44/Ez2Hk3V
qvgsl0AfdwFTFTi6XH3NoXqr8AD1yPBunwokDdx6zt1sKHTyrgbMX7GBqtBzo/4V
EyT4ZKrVah333CJycFA47QebY2m2/sqguZ7IAcRYRE9silEpTG8udIrug30WvOXC
vszpGugiLmgDH2PzKsDZ0GoxPSTXtAglfi3jJDs74IFyVOmYjLZH8UROrCq8bHbA
lAQrK2YgVaTiwXCAKaMU4d1WgAk4u7yIx3Eun1RarKzxzevcNlR+l/0=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIUeFpunAi0hIox2hJ/vxlFtF7g4P8wDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKdGVzdC5sb2NhbDAeFw0yMjAxMTkxMTM2NTRaFw0yNzAx
MTgxMTM3MjRaMCwxKjAoBgNVBAMTIXRlc3QubG9jYWwgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMZbIcIggmG8
NgWWanyIfsY+F9/ALfCjEDWJCoa/hHgp/soGCx5Md+ZEWl2Vi9UfOLAI7Uy+ZdXS
d1b1mQ/fLrAb/O69QzNT5HH6C5D5DxyTYpDzK6tyzpbU8br1f8RYU6XGi5mLg7Av
8JGmNJ/YiBwKC6tcjDXjfj9Ec4Jylxqi7zEx192s+QrlC7SVvwSQZrSSZ1xnAyug
KuVrQuY7Rkh+KO2NIXDNmuEEIEM9ua3n1PkL6QNgWCaLzGr7zEMFYrMrgN1zVR2d
1LHmoe2zsf8st8Sm2YkZNddr0SoSxdBLbximzuAajWomFwjL2RmeL1TFrTz+saVa
+H/9Rab1zJ8CAwEAAaOB1jCB0zAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQU4Sra/jGVcZDTX5GjDWnm9MugaAcwHwYDVR0jBBgwFoAU
qzVpdpEiF7tz8LnugJPleAnCOJowPAYIKwYBBQUHAQEEMDAuMCwGCCsGAQUFBzAC
hiBodHRwczovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jYTAyBgNVHR8EKzApMCeg
JaAjhiFodHRwczovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
AQELBQADggEBADXGqQKZUQGKuwqoFZp3KWuXTZo54tsuVg2ViclJs+t37FqJbEW5
4CWptpRsXZyeGbGKStmyFmTb9A/bzq4U0f0+GjRFRqhTYIqzKHGrqr0rDL30EU+z
3P+h+mO8YvxoE69utVTWxAYMtXhpKRpSoq6SRoBBkNJZQQLctutusYz216M3NqkG
g/SWuANSiDmgHgurtKiXAYQwVN5PBNi7Ztu2in/xNpKfID1A1+WxANVGfqDUU4du
YJpnSQsSmGySqeHGEcqZF0t+qp0uyt8bZXRaQ5iqifydph+1YG7sldHi8OLs5mKF
o4FY7I98ceO/uJqNHgGM1fySTqDFdNATBEw=
-----END CERTIFICATE-----
root@testsrv:~/test.local.PKI# 


```

######################################################################################
######################################################################################


5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
### Решение:
* Скопируем данные корневого сертификата на хост
```
gendalf@pc01:~$ vim CA_cert.crt
gendalf@pc01:~$ cat CA_cert.crt
-----BEGIN CERTIFICATE-----
MIIDMjCCAhqgAwIBAgIUfUcPDJkB2Oc8G4aXzRS6VIM6NYkwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKdGVzdC5sb2NhbDAeFw0yMjAxMTkxMTM2NTNaFw0yMzAx
MTkxMTM3MjNaMBUxEzARBgNVBAMTCnRlc3QubG9jYWwwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQChi0q2z5zbflZZsY8l/u3i5+PSIm91tByRiu/fwG0/
80VPcF/3kBHX2U2uy7pIngxW3AAaD7WeIOjU3dEXBXAX/Gele8KqLcDKOEBV2NWr
swT0tcM5X6HJjhkApcFY4eE99Nvgj6QuTCgYLrZHeT5CUe3NN+iu9ZXziHa5iE1t
7DBaau+PCoSUZZ4AoGGGnHRAafiCnkAQzaD09iDisD/Q7KROy099Yd30cB2tvmUb
eXWbrXbqS0n9Ga4/mQTg4VhZQUoB8SOryQwtC7Wnpfk/fh+KSz19sLzRxMVebA7r
tLPI6FA/Ay4mPyviEMn53BijUgAvq5sEGRHMQ8/By0QTAgMBAAGjejB4MA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSrNWl2kSIXu3Pw
ue6Ak+V4CcI4mjAfBgNVHSMEGDAWgBSrNWl2kSIXu3Pwue6Ak+V4CcI4mjAVBgNV
HREEDjAMggp0ZXN0LmxvY2FsMA0GCSqGSIb3DQEBCwUAA4IBAQCW3vPrOW7fc+AJ
Su2vIWZRjUmU22bPqRlKypJbi2OGseRmhn7eQgkuUqygz2eSZjqlyNl8PR8rANMO
n+5U19CM+BKQIUOXVrq/A+0IP+NyvtB2j2eB0l8fjuQkpZx9GW+arieHE2ZFQSiB
71b2c7YBCV6eKKYt72G3LUSPiHgJWmjQGk1CU6rs2KgJEUMOQgqEL1vB3lBV3dBe
DIJQjgOlQ3+UoaWEUbNVtg8aGA8PZgATIoTr4r1iXtSBJQ3IdT6u3vtMVTtPAt7W
7ErfqzVDByIijiKD071d5RkLDf3zJL7pFGIuKXjAbig1v3SfLt8Ek5QliNP6KdCV
CqEbiGEc
-----END CERTIFICATE-----
gendalf@pc01:~$ 
```

* Установим корневой сертификат в доверенные браузера на хосте
* [Скриншот1](https://raw.githubusercontent.com/easulimov/devops-netology/main/course-work/img/%D0%94%D0%BE%D0%B1%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20%D1%81%D0%B5%D1%80%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%B0%20%D0%B2%20%D0%B4%D0%BE%D0%B2%D0%B5%D1%80%D0%B5%D0%BD%D0%BD%D1%8B%D0%B5.png)
* [Скриншот2](https://raw.githubusercontent.com/easulimov/devops-netology/main/course-work/img/CA_cert.png)



######################################################################################
######################################################################################



6. Установите nginx

### Решение:
* Установка nginx
```
root@testsrv:~/test.local.PKI# apt install gnupg2 ca-certificates lsb-release ubuntu-keyring
Reading package lists... Done
Building dependency tree       
...
...
Setting up gnupg2 (2.2.19-3ubuntu2.1) ...
Processing triggers for man-db (2.9.1-1) ...
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
>     | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1561  100  1561    0     0   3941      0 --:--:-- --:--:-- --:--:--  3941
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
> http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
>     | sudo tee /etc/apt/sources.list.d/nginx.list
deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu focal nginx
root@testsrv:~/test.local.PKI# apt update
Get:1 http://nginx.org/packages/ubuntu focal InRelease [3,584 B]
...
...
14 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# 
root@testsrv:~/test.local.PKI# apt install nginx
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  nginx
0 upgraded, 1 newly installed, 0 to remove and 14 not upgraded.
Need to get 879 kB of archives.
After this operation, 3,117 kB of additional disk space will be used.
Get:1 http://nginx.org/packages/ubuntu focal/nginx amd64 nginx amd64 1.20.2-1~focal [879 kB]
Fetched 879 kB in 1s (850 kB/s)
Selecting previously unselected package nginx.
(Reading database ... 40649 files and directories currently installed.)
Preparing to unpack .../nginx_1.20.2-1~focal_amd64.deb ...
----------------------------------------------------------------------

Thanks for using nginx!

Please find the official documentation for nginx here:
* https://nginx.org/en/docs/

Please subscribe to nginx-announce mailing list to get
the most important news about nginx:
* https://nginx.org/en/support.html

Commercial subscriptions for nginx are available on:
* https://nginx.com/products/

----------------------------------------------------------------------
Unpacking nginx (1.20.2-1~focal) ...
Setting up nginx (1.20.2-1~focal) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for systemd (245.4-4ubuntu3.13) ...
root@testsrv:~/test.local.PKI#
root@testsrv:~/test.local.PKI#
root@testsrv:~/test.local.PKI# systemctl enable nginx --now
Synchronizing state of nginx.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable nginx
root@testsrv:~/test.local.PKI# systemctl status nginx
● nginx.service - nginx - high performance web server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-01-19 12:16:32 UTC; 4s ago
       Docs: https://nginx.org/en/docs/
    Process: 18446 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
   Main PID: 18458 (nginx)
      Tasks: 3 (limit: 2279)
     Memory: 2.7M
     CGroup: /system.slice/nginx.service
             ├─18458 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
             ├─18459 nginx: worker process
             └─18460 nginx: worker process

Jan 19 12:16:32 testsrv systemd[1]: Starting nginx - high performance web server...
Jan 19 12:16:32 testsrv systemd[1]: Started nginx - high performance web server.
root@testsrv:~/test.local.PKI# 
```


######################################################################################
######################################################################################



7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
  - 
### Решение 
* Создание и проверка файла конфигурации nginx
 ```
root@testsrv:~# cd /etc/nginx/conf.d/
root@testsrv:/etc/nginx/conf.d# vim testsrv.test.local.conf
root@testsrv:/etc/nginx/conf.d# cat testsrv.test.local.conf 
server {

    listen 443 default_server ssl;

    server_name testsrv.test.local 127.0.0.1;

    ssl_certificate /etc/nginx/ssl/testsrv.test.local.crt;
    ssl_certificate_key /etc/nginx/ssl/testsrv.test.local.key;


    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    keepalive_timeout 70;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }


}
root@testsrv:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@testsrv:/etc/nginx/conf.d# 
```

* Проверка файла конфигурации nginx прошла успешно. Можно перезапустить nginx
```
root@testsrv:/etc/nginx/conf.d# systemctl restart nginx
```

######################################################################################
######################################################################################


8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.

### Решение
* Добавим  адрес сервера `testsrv.test.local` в `/etc/hosts` на хосте. 
```
gendalf@pc01:~$ vim /etc/hosts
gendalf@pc01:~$ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	pc01
127.0.0.1       testsrv.test.local

gendalf@pc01:~$ 
```
* Откроем страницу в браузере. Доступ извне осуществляется через порт 4443, согласно конфига vagrant:
* [Скриншот 1](https://raw.githubusercontent.com/easulimov/devops-netology/main/course-work/img/%D0%A1%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0%20%D0%B1%D1%80%D0%B0%D1%83%D0%B7%D0%B5%D1%80%D0%B0%201.png)
* [Скриншот 2](https://raw.githubusercontent.com/easulimov/devops-netology/main/course-work/img/%D0%A1%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0%20%D0%B1%D1%80%D0%B0%D1%83%D0%B7%D0%B5%D1%80%D0%B0%202.png)
* [Скриншот 3](https://raw.githubusercontent.com/easulimov/devops-netology/main/course-work/img/%D0%A1%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0%20%D0%B1%D1%80%D0%B0%D1%83%D0%B7%D0%B5%D1%80%D0%B0_%D0%BF%D1%80%D0%BE%D1%81%D0%BC%D0%BE%D1%82%D1%80%20%D1%81%D0%B5%D1%80%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%B0.png)

######################################################################################
######################################################################################


9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
  
### Решение
* Создадим скрипт
```
root@testsrv:/etc/nginx/conf.d# cd ~/test.local.PKI/
root@testsrv:~/test.local.PKI# vim gen_nginx_cert.sh
root@testsrv:~/test.local.PKI# chmod +x gen_nginx_cert.sh 
root@testsrv:~/test.local.PKI# ll gen_nginx_cert.sh 
-rwxr-xr-x 1 root root 570 Jan 19 12:54 gen_nginx_cert.sh*
root@testsrv:~/test.local.PKI# 
```

* Содержимое скрипта
```bash
#!/usr/bin/env bash

export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_TOKEN=s.gtFWQnJh4C7ZpDLeK9d2RG6A

vault write -format=json pki_int/issue/test-dot-local \
    common_name=testsrv.test.local  ttl="720h" > testsrv.test.local.crt.file

cat testsrv.test.local.crt.file | jq -r .data.certificate > /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.issuing_ca >> /etc/nginx/ssl/testsrv.test.local.crt
cat testsrv.test.local.crt.file | jq -r .data.private_key > /etc/nginx/ssl/testsrv.test.local.key

systemctl restart nginx.service
```

######################################################################################
######################################################################################


10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

### Решение
* Создание файла crontab для текущего пользователя. Запуск скритпа `/root/test.local.PKI/gen_nginx_cert.sh` в последний день каждого месяца в 23:00
```bash
root@testsrv:~/test.local.PKI# crontab -e
root@testsrv:~/test.local.PKI# crontab -l
SHELL=/bin/bash
MAILTO = ""
0 23 * * * [[ "$(date +\%d -d tomorrow)" == "01" ]] && /root/test.local.PKI/gen_nginx_cert.sh
root@testsrv:~/test.local.PKI# 
```


