
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
    
    
4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).
    ### Решение
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
    ### Решение 
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
    ### Решение
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
    ### Решение
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443
