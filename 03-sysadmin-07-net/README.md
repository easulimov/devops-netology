1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
    ### Решение
    * Для Linux:
    ```
       vagrant@vagrant:~$ ip -c -br link
       lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
       eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
       vagrant@vagrant:~$ ip a
       1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
           link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
           inet 127.0.0.1/8 scope host lo
              valid_lft forever preferred_lft forever
           inet6 ::1/128 scope host 
              valid_lft forever preferred_lft forever
       2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
           link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
           inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
              valid_lft 55563sec preferred_lft 55563sec
           inet6 fe80::a00:27ff:fe73:60cf/64 scope link 
              valid_lft forever preferred_lft forever
       vagrant@vagrant:~$ 
    
    ```
    * Также, в Linux, инфорацию о физичеcких сетевых интерфейсах можно посмотреть с помощью команды:
    ```
       vagrant@vagrant:~$ sudo lshw -class network
         *-network                 
              description: Ethernet interface
              product: 82540EM Gigabit Ethernet Controller
              vendor: Intel Corporation
              physical id: 3
              bus info: pci@0000:00:03.0
              logical name: eth0
              version: 02
              serial: 08:00:27:73:60:cf
              size: 1Gbit/s
              capacity: 1Gbit/s
              width: 32 bits
              clock: 66MHz
              capabilities: pm pcix bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
              configuration: autonegotiation=on broadcast=yes driver=e1000 driverversion=7.3.21-k8-NAPI duplex=full ip=10.0.2.15 latency=64 link=yes mingnt=255 multicast=yes port=twisted pair speed=1Gbit/s
              resources: irq:19 memory:f0000000-f001ffff ioport:d010(size=8)
       vagrant@vagrant:~$    
    ```
    * Для Windows:
    ```
       Microsoft Windows [Version 10.0.19043.1348]
       (c) Корпорация Майкрософт (Microsoft Corporation). Все права защищены.
       
       C:\Users\User>netsh interface show interface
       
       Состояние адм.  Состояние     Тип              Имя интерфейса
       ---------------------------------------------------------------------
       Разрешен       Отключен       Выделенный       Slot01 x8
       Разрешен       Подключен      Выделенный       eth0
       Разрешен       Отключен       Выделенный       Slot02 x16
       
       
       C:\Users\User>ipconfig /all
       
       Настройка протокола IP для Windows
       
          Имя компьютера  . . . . . . . . . : DESKTOP-L3CAS6J
          Основной DNS-суффикс  . . . . . . :
          Тип узла. . . . . . . . . . . . . : Гибридный
          IP-маршрутизация включена . . . . : Нет
          WINS-прокси включен . . . . . . . : Нет
       
       Адаптер Ethernet Slot01 x8:
       
          Состояние среды. . . . . . . . : Среда передачи недоступна.
          DNS-суффикс подключения . . . . . :
          Описание. . . . . . . . . . . . . : Realtek PCIe GbE Family Controller
          Физический адрес. . . . . . . . . : 00-E0-4C-99-8C-5F
          DHCP включен. . . . . . . . . . . : Да
          Автонастройка включена. . . . . . : Да
       
       Адаптер Ethernet Slot02 x16:
       
          Состояние среды. . . . . . . . : Среда передачи недоступна.
          DNS-суффикс подключения . . . . . :
          Описание. . . . . . . . . . . . . : Realtek PCIe GbE Family Controller #2
          Физический адрес. . . . . . . . . : 00-E0-4C-99-8D-8C
          DHCP включен. . . . . . . . . . . : Да
          Автонастройка включена. . . . . . : Да
       
       Адаптер Ethernet eth0:

          DNS-суффикс подключения . . . . . :
          Описание. . . . . . . . . . . . . : Intel(R) Ethernet Connection (2) I218-LM
          Физический адрес. . . . . . . . . : E0-4F-43-29-25-23
          DHCP включен. . . . . . . . . . . : Да
          Автонастройка включена. . . . . . : Да
          Локальный IPv6-адрес канала . . . : fe80::691b:ef2:c17b:7a46%15(Основной)
          IPv4-адрес. . . . . . . . . . . . : 192.168.8.104(Основной)
          Маска подсети . . . . . . . . . . : 255.255.255.0
          Аренда получена. . . . . . . . . . : 13 декабря 2021 г. 8:53:54
          Срок аренды истекает. . . . . . . . . . : 15 декабря 2021 г. 8:53:53
          Основной шлюз. . . . . . . . . : fe80::aac8:3aff:fe0f:e325%15
                                              192.168.8.1
          DHCP-сервер. . . . . . . . . . . : 192.168.8.1
          IAID DHCPv6 . . . . . . . . . . . : 98586435
          DUID клиента DHCPv6 . . . . . . . : 00-01-00-01-23-E3-13-3A-E0-4F-43-29-25-23
          DNS-серверы. . . . . . . . . . . : fe80::aac8:3aff:fe0f:e325%15
                                              192.168.8.1
                                              192.168.8.1
          NetBios через TCP/IP. . . . . . . . : Включен

       C:\Users\User>
    ```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
    ### Решение
* `Link Layer Discovery Protocol (LLDP)` — протокол канального уровня, который позволяет сетевым устройствам анонсировать в сеть информацию о себе и о своих возможностях, а также собирать эту информацию о соседних устройствах.
* Пакет в Ubuntu:
```
    vagrant@vagrant:~$ sudo apt search lldp
    Sorting... Done
    Full Text Search... Done
    
    lldpd/focal,now 1.0.4-1build2 amd64 [installed]
      implementation of IEEE 802.1ab (LLDP)
    
    vagrant@vagrant:~$ 
```
* Управление производится с помощью команд `lldpcli` и `lldpctl`. `lldpcli` -  запустит интерактивную оболочку, которую можно использовать для ввода произвольных команд, как если бы они были указаны в командной строке. `lldpctl` - отобразит подробную информацию о каждом соседе по указанным интерфейсам или по всем интерфейсам, если ни один из них не указан. Например:
```

    $ sudo lldpctl
    -------------------------------------------------------------------------------
        LLDP neighbors
    -------------------------------------------------------------------------------
    Interface: eth3
     ChassisID: 00:15:60:79:8e:c0 (MAC)
     SysName:   mossy
     SysDescr:  
       ProCurve J4906A Switch 3400cl-48G, revision M.10.06, ROM I.08.11 (/sw/code/build/makf(ts_08_5))
     MgmtIP:    192.168.18.1
     Caps:      Bridge(E) Router(E) 
    
     PortID:    1 (local)
     PortDescr: 1
    -------------------------------------------------------------------------------
```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
    ### Решение
* Для разделения L2 коммутатора на несколько виртуальных сетей используется технология VLAN (Virtual Local Area Network)
* В Linux для использоватния технологии VLAN требуется установка одноименного пакета:
```
    vagrant@vagrant:~$ sudo apt info vlan
    Package: vlan
    Version: 2.0.4ubuntu1.20.04.1
    ...
    vagrant@vagrant:~$ sudo apt install vlan
    ...
```
* Для использования возможностей требуется проверить, что загружен модуль ядра `8021q` (если он не загружен, требуется воспользоваться командой `modprobe 8021q`, и `sudo su -c 'echo "8021q" >> /etc/modules'` - чтобы включить перманентно):
```
    vagrant@vagrant:~$ sudo lsmod | grep 8021q
    8021q                  32768  0
    garp                   16384  1 8021q
    mrp                    20480  1 8021q
    vagrant@vagrant:~$ 
```
* Для настройки интерфейса VLAN можно испоьзовать команду `IP`:
```
    vagrant@vagrant:~$ ip -c -br link
    lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
    eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
    vagrant@vagrant:~$ sudo ip link add link eth0 name eth0.10 type vlan id 10
    vagrant@vagrant:~$ 
    vagrant@vagrant:~$ ip -c -d link show eth0.10
    3: eth0.10@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 
    vlan protocol 802.1Q id 10 <REORDER_HDR> addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
    vagrant@vagrant:~$ 
    vagrant@vagrant:~$ ip -c -br link
    lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
    eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
    eth0.10@eth0     DOWN           08:00:27:73:60:cf <BROADCAST,MULTICAST> 
    vagrant@vagrant:~$ sudo ip addr add 192.168.1.200/24 brd 192.168.1.255 dev eth0.10
    vagrant@vagrant:~$ sudo ip link set dev eth0.10 up
    vagrant@vagrant:~$ ip -c -br link
    lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
    eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
    eth0.10@eth0     UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
    vagrant@vagrant:~$ 
    vagrant@vagrant:~$ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 74405sec preferred_lft 74405sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link 
       valid_lft forever preferred_lft forever
    3: eth0.10@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.200/24 brd 192.168.1.255 scope global eth0.10
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fe73:60cf/64 scope link 
           valid_lft forever preferred_lft forever
   vagrant@vagrant:~$ 
```
* Для внесения изменений на постоянной основе, потребуется потребуется изменить конфиг netplan `/etc/netplan/01-netcfg.yaml`


4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
    ### Решение
    * В Linux для агрегации интерфейсов используется `Bonding`
    * У `Bonding` - есть несколько опций для балансировки нагрузки:
        *  `balance-rr` или 0 - политика round-robin. Пакеты отправляются последовательно, начиная с первого доступного интерфейса и заканчивая последним. Э
        *  `balance-xor` или 2 - политика XOR. Передача распределяется между сетевыми картами используя формулу: [( «MAC адрес источника» XOR «MAC адрес назначения») по модулю «число интерфейсов»]. Получается одна и та же сетевая карта передаёт пакеты одним и тем же получателям. Опционально распределение передачи может быть основано и на политике «xmit_hash». 
        *   `balance-tlb` или 5 - политика адаптивной балансировки нагрузки передачи. Исходящий трафик распределяется в зависимости от загруженности каждой сетевой карты (определяется скоростью загрузки). Не требует дополнительной настройки на коммутаторе. Входящий трафик приходит на текущую сетевую карту. Если она выходит из строя, то другая сетевая карта берёт себе MAC адрес вышедшей из строя карты. 
        *   `balance-alb` или 6 - политика адаптивной балансировки нагрузки. Включает в себя политику balance-tlb плюс осуществляет балансировку входящего трафика. Не требует дополнительной настройки на коммутаторе. Балансировка входящего трафика достигается путём ARP переговоров. Драйвер bonding перехватывает ARP ответы, отправляемые с локальных сетевых карт наружу, и переписывает MAC адрес источника на один из уникальных MAC адресов сетевой карты, участвующей в объединении. Таким образом различные пиры используют различные MAC адреса сервера. Балансировка входящего трафика распределяется последовательно (round-robin) между интерфейсами.
     * Подготовка к настройке `bonding`. Включим поддержку ядра и установим пакет `ifenslave`:
     ```   
         vagrant@ubuntu02:~$ sudo apt install ifenslave
         ...
         vagrant@ubuntu02:~$ sudo modprobe bonding
         vagrant@ubuntu02:~$ lsmod | grep bonding
         bonding               167936 
         vagrant@ubuntu02:~$ sudo su -c 'echo "bonding" >> /etc/modules'
         vagrant@ubuntu02:~$ cat /etc/modules
         # /etc/modules: kernel modules to load at boot time.
         #
         # This file contains the names of kernel modules that should be loaded
         # at boot time, one per line. Lines beginning with "#" are ignored.
         
         bonding
     ```
     * `bonding` - пример конфига
     ```
        root@ubuntu01:~# ip -c -br link
        lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
        eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP> 
        eth1             UP             08:00:27:53:2d:4a <BROADCAST,MULTICAST,UP,LOWER_UP> 
        eth2             UP             3e:d2:b8:7c:64:e2 <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> 
        eth3             UP             3e:d2:b8:7c:64:e2 <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> 
        bond0            UP             3e:d2:b8:7c:64:e2 <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> 
        root@ubuntu01:~# ip -c r
        default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
        10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
        10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
        192.168.8.0/24 dev bond0 proto kernel scope link src 192.168.8.10 
        192.168.8.0/24 via 192.168.8.10 dev bond0 proto static 
        192.168.56.0/24 dev eth1 proto kernel scope link src 192.168.56.10 
        root@ubuntu01:~# cat /proc/net/bonding/bond0 
        Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

        Bonding Mode: load balancing (round-robin)
        MII Status: up
        MII Polling Interval (ms): 100
        Up Delay (ms): 0
        Down Delay (ms): 0
        Peer Notification Delay (ms): 0

        Slave Interface: eth3
        MII Status: up
        Speed: 1000 Mbps
        Duplex: full
        Link Failure Count: 0
        Permanent HW addr: 08:00:27:41:39:87
        Slave queue ID: 0

        Slave Interface: eth2
        MII Status: up
        Speed: 1000 Mbps
        Duplex: full
        Link Failure Count: 0
        Permanent HW addr: 08:00:27:bd:e7:f2
        Slave queue ID: 0
        root@ubuntu01:~# cat /etc/netplan/20-bonding.yaml 
        network:
          version: 2
          renderer: networkd
          ethernets:
            eth2:
              dhcp4: no
            eth3:
              dhcp4: no
          bonds:
            bond0:
              interfaces: [eth2, eth3]
              addresses: [192.168.8.10/24]
              parameters:
                 mode: balance-rr
                 mii-monitor-interval: 100
              routes:
                 - to: 192.168.8.0/24
                   via: 192.168.8.10
                   on-link: true
        root@ubuntu01:~# 
     
     ```
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
    ### Решение
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
    ### Решение
7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
    ### Решение


 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
 ---

