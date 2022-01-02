
1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
    ### Решение
    * Выполнено [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Bitwarden%20browser%20plug-in.png)

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
    ### Решение
    * Включение двухфакторной аутентификации в настройках профиля Bitwarden [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Bitwarden%20with%20GoogleAuth.png)
    * Запрос ключа Google authenticator при попытке входа в личный кабинет Bitwarden [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Access%20with%20GoogleAuth%20code.png)
    
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
    ### Решение
    * Подготовим тестовую среду. Создадим в папке, в которой находится `Vagrantfile` папку с html страницей "заглушкой" и скрипт для установки `apache2`:
    ```  
        gendalf@pc01:~/vagrantdir$ mkdir html
        gendalf@pc01:~/vagrantdir$ cd html
        gendalf@pc01:~/vagrantdir/html$ vim index.html
        gendalf@pc01:~/vagrantdir/html$ cat index.html
        
        <!DOCTYPE html>
        <html> 
            <head>
                <title>Apache2 Test</title>   
            </head>
            <body>    
        	<h1>Test page Apache2 deployed with Vagrant</h1>  
            </body>
        </html>
        gendalf@pc01:~/vagrantdir/html$ cd ..
        gendalf@pc01:~/vagrantdir$ vim setup.sh
        gendalf@pc01:~/vagrantdir$ chmod +x setup.sh
        gendalf@pc01:~/vagrantdir$ cat setup.sh 
        #!/usr/bin/env bash
        
        apt-get update
        apt-get install -y apache2
        if ! [ -L /var/www ]; then
            rm -rf /var/www
            ln -fs /vagrant /var/www
        fi
        gendalf@pc01:~/vagrantdir$  
    ```
    * Скорректируем `Vagrantfile`, чтобы был доступ с хоста к гостевой вирутальной машине, а также используем ранее подготовленный скрипт для автоматической установки `apache2` и использования сайта заглушки из автоматически смонтированной папки `/vagrant` (путь `/var/www` символическая ссылка на папку /vagrant, которая смонтирована с хостом):
    ```
        gendalf@pc01:~/vagrantdir$ vim Vagrantfile 
        gendalf@pc01:~/vagrantdir$ cat Vagrantfile 
         Vagrant.configure("2") do |config|
         	config.vm.box = "bento/ubuntu-20.04"
                config.vm.provider "virtualbox" do |v|  
                    v.memory = 2048
                    v.cpus = 3
                    v.name = "apachevm"
                end
                config.vm.network "forwarded_port", guest: 80, host: 4848
                config.vm.network "forwarded_port", guest: 443, host: 4949
                config.vm.provision :shell, path: "setup.sh"
         end
        gendalf@pc01:~/vagrantdir$ 
    ```
    * Проверим сайт после запуска виртуальной машины. Введем URL `http://127.0.0.1:4848/` в браузере. [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Apache2%20http%20access.png)
    * Активируем модуль Apache mod_ssl, который предоставляет поддержку шифрования SSL:
    ```
       vagrant@vagrant:~$ sudo a2enmod ssl
       Considering dependency setenvif for ssl:
       Module setenvif already enabled
       Considering dependency mime for ssl:
       Module mime already enabled
       Considering dependency socache_shmcb for ssl:
       Enabling module socache_shmcb.
       Enabling module ssl.
       See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
       To activate the new configuration, you need to run:
         systemctl restart apache2
       vagrant@vagrant:~$ sudo systemctl restart apache2
       vagrant@vagrant:~$ 
    ```
    * Используем `openssl` для генерации самоподписного сертификата:
    ```
        vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /etc/ssl/private/apch2_selfsign.key -out /etc/ssl/certs/apch2_selfsign.crt
        Generating a RSA private key
        .........++++
        .................++++
        writing new private key to '/etc/ssl/private/apch2_selfsign.key'
        -----
        You are about to be asked to enter information that will be incorporated
        into your certificate request.
        What you are about to enter is what is called a Distinguished Name or a DN.
        There are quite a few fields but you can leave some blank
        For some fields there will be a default value,
        If you enter '.', the field will be left blank.
        -----
        Country Name (2 letter code) [AU]:RU
        State or Province Name (full name) [Some-State]:Moscow region
        Locality Name (eg, city) []:Dolgoprudny
        Organization Name (eg, company) [Internet Widgits Pty Ltd]:TestOrganization
        Organizational Unit Name (eg, section) []:
        Common Name (e.g. server FQDN or YOUR name) []:Evgeniy
        Email Address []:fox_su18@mail.ru
        vagrant@vagrant:~$ 
    ```
    * Изменим конфигурацию `Apache2` по-умолчанию:
    ```
       root@vagrant:/etc/apache2/sites-available# vim 000-default.conf 
       root@vagrant:/etc/apache2/sites-available# cat 000-default.conf 
       <VirtualHost *:80>
       	        ServerAdmin webmaster@localhost
                # DocumentRoot /var/www/html
                Redirect permanent / https://127.0.0.1:4949

       	        ErrorLog ${APACHE_LOG_DIR}/error.log
       	        CustomLog ${APACHE_LOG_DIR}/access.log combined
       </VirtualHost>
       <IfModule mod_ssl.c>
               <VirtualHost _default_:443>
                       ServerAdmin webmaster@localhost
       
                       DocumentRoot /var/www/html
       
                       #LogLevel info ssl:warn

                       ErrorLog ${APACHE_LOG_DIR}/error.log
                       CustomLog ${APACHE_LOG_DIR}/access.log combined
       
                       #   SSL Engine Switch:
                       #   Enable/Disable SSL for this virtual host.
                       SSLEngine on
       
                       #   SSLCertificateFile directive is needed.
                       SSLCertificateFile      /etc/ssl/certs/apch2_selfsign.crt
                       SSLCertificateKeyFile /etc/ssl/private/apch2_selfsign.key

                       #SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
                       <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                       SSLOptions +StdEnvVars
                       </FilesMatch>
                       <Directory /usr/lib/cgi-bin>
                                       SSLOptions +StdEnvVars
                       </Directory>
               </VirtualHost>
       </IfModule>
       # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
       root@vagrant:/etc/apache2/sites-available# sudo apache2ctl configtest
       Syntax OK
       root@vagrant:/etc/apache2/sites-available# sudo systemctl reload apache2
       root@vagrant:/etc/apache2/sites-available# 
    ```
    * Добавим самоподписной сертификат в доверенные, в браузере на хосте [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Cert%20added%20to%20trusted.png)
    * Проверим сайт заглушку в браузере на хосте (`https://127.0.0.1:4949`) [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Test%20https%20access%20from%20host.png)
    
4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).
    ### Решение
    * Установим скрипт для проверки уязвимостей и проверим сайт `seaspace.xyz`:
    ```
        vagrant@vagrant:~$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git
        vagrant@vagrant:~$ cd testssl.sh/
        vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://seaspace.xyz
        
        ###########################################################
            testssl.sh       3.1dev from https://testssl.sh/dev/
            (3827521 2021-12-27 17:11:36 -- )
        
              This program is free software. Distribution and
                     modification under GPLv2 permitted.
             USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!
        
               Please file bugs @ https://testssl.sh/bugs/
        
        ###########################################################
        
         Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
         on vagrant:./bin/openssl.Linux.x86_64
         (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")
        
        
         Start 2022-01-02 13:42:03        -->> 194.67.108.201:443 (seaspace.xyz) <<--
                
         rDNS (194.67.108.201):  194-67-108-201.cloudvps.regruhosting.ru.
         Service detected:       HTTP
        
        
         Testing vulnerabilities 
        
         Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
         CCS (CVE-2014-0224)                       not vulnerable (OK)
         Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
         ROBOT                                     not vulnerable (OK)
         Secure Renegotiation (RFC 5746)           supported (OK)
         Secure Client-Initiated Renegotiation     not vulnerable (OK)
         CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
         BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
         POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
         TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
         SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
         FREAK (CVE-2015-0204)                     not vulnerable (OK)
         DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                                   make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=9819EA43CEBC9EEF3121EDB201D11923BC4BE84BE7B7FA7E7E0D1663F096C0B4 could help you to find out
         LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
         BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES256-SHA
                                                         ECDHE-RSA-AES128-SHA
                                                         ECDHE-RSA-DES-CBC3-SHA
                                                         AES128-SHA AES256-SHA
                                                         DES-CBC3-SHA 
                                                   VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
         LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
         Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
         RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)

        
         Done 2022-01-02 13:42:48 [  47s] -->> 194.67.108.201:443 (seaspace.xyz) <<--
        
        
        vagrant@vagrant:~/testssl.sh$ 

    ```
    
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
    ### Решение 
    * Установим на виртуальной машине ssh сервер и добавим нового пользователя:
    ```
        root@vagrant:~# apt install -y openssh-server
        root@vagrant:~# systemctl start sshd.service
        root@vagrant:~# systemctl enable sshd.service
        root@vagrant:~# adduser bart
        Adding user `bart' ...
        Adding new group `bart' (1001) ...
        Adding new user `bart' (1001) with group `bart' ...
        Creating home directory `/home/bart' ...
        Copying files from `/etc/skel' ...
        New password: 
        Retype new password: 
        ...
        Is the information correct? [Y/n] y

    ```
    * Сгененрируем ssh ключи на хосте c помощью `ssh-keygen` и скопируем их с помощью `ssh-copy-id` в директорию пользователя `bart`, расположенную на виртуальной машине:
    ```
        gendalf@pc01:~/.ssh$ ssh-keygen -t rsa -b 4096 -C "TestKey"
        Generating public/private rsa key pair.
        Enter file in which to save the key (/home/gendalf/.ssh/id_rsa): 
        Enter passphrase (empty for no passphrase): 
        Enter same passphrase again: 
        Your identification has been saved in /home/gendalf/.ssh/id_rsa
        Your public key has been saved in /home/gendalf/.ssh/id_rsa.pub
        ...
        
        gendalf@pc01:~/.ssh$ ssh-copy-id -p 2222 bart@localhost
        The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
        ECDSA key fingerprint is SHA256:wSHl+h4vAtTT7mbkj2lbGyxWXWTUf6VUliwpncjwLPM.
        Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 2 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        bart@localhost's password: 
        
        Number of key(s) added: 2
        
        Now try logging into the machine, with:   "ssh -p '2222' 'bart@localhost'"
        and check to make sure that only the key(s) you wanted were added.
        
        gendalf@pc01:~/.ssh$ ssh -p 2222 bart@localhost
        
    ```
    * Подключимся к вируальной машине:
    ```
        gendalf@pc01:~/.ssh$ ssh -p 2222 bart@localhost
        Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
        
         * Documentation:  https://help.ubuntu.com
         * Management:     https://landscape.canonical.com
         * Support:        https://ubuntu.com/advantage
        
          System information as of Sun 02 Jan 2022 02:18:06 PM UTC
        
          System load:  0.0               Processes:             137
          Usage of /:   2.6% of 61.31GB   Users logged in:       1
          Memory usage: 12%               IPv4 address for eth0: 10.0.2.15
          Swap usage:   0%
          ...

          bart@vagrant:~$ 
              
    ```
    
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
    ### Решение
    * Переименуем ранее сгенерированные ключи и создадим файл конфигурации:
   ```
       gendalf@pc01:~/.ssh$ mv id_rsa vagrantvm_rsa
       gendalf@pc01:~/.ssh$ mv id_rsa.pub vagrantvm_rsa.pub
       gendalf@pc01:~/.ssh$ mv id_rsa vagrantvm_rsa
       gendalf@pc01:~/.ssh$ mv id_rsa.pub vagrantvm_rsa.pub
       gendalf@pc01:~/.ssh$ vim config
       gendalf@pc01:~/.ssh$ cat config
       Host vagrantvm 
            HostName 127.0.0.1
            IdentityFile ~/.ssh/vagrantvm_rsa
            User bart
            Port 2222
            StrictHostKeyChecking no
            gendalf@pc01:~/.ssh$ ssh vagrantvm 
            Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
            
             * Documentation:  https://help.ubuntu.com
             * Management:     https://landscape.canonical.com
             * Support:        https://ubuntu.com/advantage
            
              System information as of Sun 02 Jan 2022 02:51:22 PM UTC
            
              System load:  0.0               Processes:             137
              Usage of /:   2.6% of 61.31GB   Users logged in:       1
              Memory usage: 12%               IPv4 address for eth0: 10.0.2.15
              Swap usage:   0%
            ...

       bart@vagrant:~$ 
   
   ```
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
    ### Решение
    * Запустим `tcpdump` на хосте и откроем несколько страниц в браузере:
    ```  
       root@pc01😎:~# tcpdump -c 100 -w test_100.pcap -i wlx9848273b728b
       tcpdump: listening on wlx9848273b728b, link-type EN10MB (Ethernet), snapshot length 262144 bytes
       100 packets captured
       274 packets received by filter
       0 packets dropped by kernel
       root@pc01😎:~# 
    ```
    * Установим `Wireshark` и откроем ранее полученный файл в формате `pcap`:
    ```
        root@pc01😎:~# apt install -y wireshark
        root@pc01😎:~# wireshark -r test_100.pcap 
 
    ```
    * [Скриншот1](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Wireshark1.png)
    * [Скриншот2](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-09-security/img/Wireshark2.png)
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443
