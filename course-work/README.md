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


## Решение:
1. Создайте виртуальную машину Linux.
```
gendalf@pc01:~$ mkdir course-work
gendalf@pc01:~$ cd course-work/
gendalf@pc01:~/course-work$ vim Vagrantfile 
gendalf@pc01:~/course-work$ cat Vagrantfile 
 Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
            v.name = "testvm"
        end
        config.vm.network "forwarded_port", guest: 443, host: 4949
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
```

2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
*  ufw
```
vagrant@vagrant:~$ sudo -i
root@vagrant:~# ufw status
Status: inactive
root@vagrant:~# 
root@vagrant:~# 
root@vagrant:~# ufw allow from 127.0.0.0/8
Rules updated
root@vagrant:~# ufw allow 22/tcp
Rules updated
Rules updated (v6)
root@vagrant:~# ufw allow 443/tcp
Rules updated
Rules updated (v6)
root@vagrant:~# ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
root@vagrant:~# 
root@vagrant:~# 
root@vagrant:~# ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
root@vagrant:~# 
root@vagrant:~# 
root@vagrant:~# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? Y
Firewall is active and enabled on system startup
root@vagrant:~# 
root@vagrant:~# ufw status verbose
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

root@vagrant:~# 
```
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
```
root@vagrant:~# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
root@vagrant:~# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
...
root@vagrant:~# sudo apt-get update && sudo apt-get install vault
...
root@vagrant:~# which vault
/usr/bin/vault
root@vagrant:~# vault --version
Vault v1.9.2 (f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf)
root@vagrant:~# 
root@vagrant:~# 
root@vagrant:~# vim /etc/vault.d/vault.hcl 
root@vagrant:~# cat /etc/vault.d/vault.hcl 
ui = true

storage "file" {
  path = "/opt/vault/data"
}


# HTTPS listener
listener "tcp" {
  address       = "127.0.0.1:8200"
  tls_cert_file = "/opt/vault/tls/tls.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
}
root@vagrant:~# 
root@vagrant:~# 
root@vagrant:~# systemctl enable vault --now
root@vagrant:~# systemctl is-enabled vault.service
enabled
root@vagrant:~# systemctl status vault.service
● vault.service - "HashiCorp Vault - A tool for managing secrets"
     Loaded: loaded (/lib/systemd/system/vault.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-01-12 15:05:51 UTC; 38s ago
       Docs: https://www.vaultproject.io/docs/
   Main PID: 4302 (vault)
      Tasks: 8 (limit: 2279)
     Memory: 58.2M
     CGroup: /system.slice/vault.service
             └─4302 /usr/bin/vault server -config=/etc/vault.d/vault.hcl
...
root@vagrant:~# 
```
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
5. 
