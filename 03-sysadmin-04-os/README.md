
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
    * Создадим конфигурационный файл, для возможности добавления опций к запускаемому процессу в будущем. Список опций можно посмотреть `node_exporter --help`: 
    ```
        sudo bash -c "echo "OPTIONS=\'\'" > /etc/default/node_exporter.conf"    
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
        EnvironmentFile=-/etc/default/node_exporter.conf
        ExecStart=/usr/local/bin/node_exporter $OPTIONS
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
        vagrant@vagrant:~$ sudo reboot
        Connection to 127.0.0.1 closed by remote host.
        Connection to 127.0.0.1 closed.
        MacBook-Pro-admin:vagrant admin$ vagrant ssh
        Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
                
         * Documentation:  https://help.ubuntu.com
         * Management:     https://landscape.canonical.com
         * Support:        https://ubuntu.com/advantage
        
          System information as of Tue 07 Dec 2021 12:17:22 PM UTC
                
          System load:  0.06              Processes:             122
          Usage of /:   3.1% of 61.31GB   Users logged in:       0
          Memory usage: 8%                IPv4 address for eth0: 10.0.2.15
          Swap usage:   0%
        
        
        This system is built by the Bento project by Chef Software
        More information can be found at https://github.com/chef/bento
        Last login: Tue Dec  7 12:09:03 2021 from 10.0.2.2
        vagrant@vagrant:~$ sudo systemctl status node_exporter
        ● node_exporter.service - Node Exporter
             Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
             Active: active (running) since Tue 2021-12-07 12:17:05 UTC; 21s ago
           Main PID: 707 (node_exporter)
              Tasks: 5 (limit: 2279)
             Memory: 13.4M
             CGroup: /system.slice/node_exporter.service
                     └─707 /usr/local/bin/node_exporter

          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=thermal_zone
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=time
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=timex
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=udp_queues
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=uname
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=vmstat
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=xfs
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:115 level=info collector=zfs
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
          Dec 07 12:17:05 vagrant node_exporter[707]: ts=2021-12-07T12:17:05.529Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
          vagrant@vagrant:~$ 
    
    ```
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
    ### Решение:
    * ` curl http://localhost:9100/metrics | less`
    * CPU
    ```
        node_cpu_seconds_total{cpu="0",mode="system"} 2.67
        node_cpu_seconds_total{cpu="0",mode="user"} 1.35 
        node_cpu_seconds_total{cpu="0",mode="idle"} 3347.64
        node_cpu_seconds_total{cpu="0",mode="iowait"} 1.76
        node_cpu_seconds_total{cpu="0",mode="irq"} 0
        node_cpu_seconds_total{cpu="0",mode="nice"} 0
        node_cpu_seconds_total{cpu="0",mode="softirq"} 0.26
        node_cpu_seconds_total{cpu="0",mode="steal"} 0

    ```
    * RAM
    ```
        node_memory_MemTotal_bytes 2.08408576e+09
        node_memory_MemFree_bytes 1.463975936e+09
        node_memory_Cached_bytes 4.49765376e+08
        node_memory_Buffers_bytes 2.4420352e+07
        node_memory_MemAvailable_bytes 1.815252992e+09       
    ```
    * Disk
    ```
        node_filesystem_size_bytes{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 6.5827115008e+10
        node_filesystem_avail_bytes{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 6.0401176576e+10
        node_filesystem_files{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 4.104192e+06
        node_filesystem_device_error{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 0
        node_disk_io_time_seconds_total{device="dm-0"} 5.836
        node_disk_io_time_seconds_total{device="dm-1"} 0.04
        node_disk_io_time_seconds_total{device="sda"} 5.908
    ```
    * Network
    ```
        node_network_receive_bytes_total{device="eth0"} 131820
        node_network_receive_errs_total{device="eth0"} 0
        node_network_transmit_bytes_total{device="eth0"} 308022
        node_network_transmit_errs_total{device="eth0"} 0
    ```
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
