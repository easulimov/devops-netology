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

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?



 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
 ---

