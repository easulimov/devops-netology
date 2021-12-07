
1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

    ### Решение:
    * Предварительно создадим пользователя, от имени которого будет запускаться node-exporter: 
    ```
        sudo useradd --no-create-home --shell /bin/false node_exporter
    ```
    * Скачиваем `node-exporter` c помощью команды:
    ```
        wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
    ```
    * Распаковываем содержимое архива: 
    ```
        tar -xvf node_exporter-1.3.1.linux-amd64.tar.gz
    ```
    * Скопируем исполняемый файл в `/usr/local/bin` и изменим владельца и группу владельца на ранее созданного `node_exporter`: 
    ```
        sudo cp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
        sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
    ```
    * Cоздадим новый unit-файл для `node-exporter`: 
    ```
        sudo vim /etc/systemd/system/node_exporter.service
    ```
    ```
        [Unit]
        Description=Node Exporter
        Wants=network-online.target
        After=network-online.target
        
        [Service]
        User=node_exporter
        Group=node_exporter
        Type=simple
        ExecStart=/usr/local/bin/node_exporter
        ExecReload=/bin/kill -HUP $MAINPID
        Restart=on-failure

        [Install]
        WantedBy=multi-user.target
    ```
    * Перечитаем конфигурацию `systemd`, а также запустим наш новый юнит и добавим его в автозагрузку: 
    ```
        sudo systemctl daemon-reload
        sudo systemctl start node_exporter
        sudo systemctl enable node_exporter
    ```
    * Перезагрузим виртуальную машину и проверим статус юнита `node_exporter`:
    ```
        sudo reboot
        vagrant ssh
        sudo systemctl status node_exporter 
    ```
    * Вывод команды сатус после перезагрузки:
    ```
        This system is built by the Bento project by Chef Software
        More information can be found at https://github.com/chef/bento
        Last login: Mon Dec  6 14:37:09 2021 from 10.0.2.2
        vagrant@vagrant:~$ sudo systemctl status node_exporter 
        ● node_exporter.service - Node Exporter
             Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset>
             Active: active (running) since Tue 2021-11-23 18:25:01 UTC; 1 weeks 6 days ago
           Main PID: 714 (node_exporter)
              Tasks: 5 (limit: 2279)
             Memory: 13.3M
             CGroup: /system.slice/node_exporter.service
                     └─714 /usr/local/bin/node_exporter
        
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.226Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.227Z caller=node_ex>
        Nov 23 18:25:01 vagrant node_exporter[714]: ts=2021-11-23T18:25:01.227Z caller=tls_con>
        lines 1-19/19 (END)
    
    ```
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
### Решение:

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
### Решение:

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
### Решение:

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
### Решение:

6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
### Решение:

7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
### Решение:
