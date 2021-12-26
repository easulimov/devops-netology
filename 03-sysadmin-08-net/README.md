1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
    telnet route-views.routeviews.org
    Username: rviews
    show ip route x.x.x.x/32
    show bgp x.x.x.x/32
```
### Решение
* Узнаем свой IP
```
    root@vagrant:~# curl ifconfig.me
    31.173.84.141root@vagrant:~# 
```
* Проверим маршруты для 31.173.84.141/32:
```
   root@vagrant:~# telnet route-views.routeviews.org
   Trying 128.223.51.103...
   Connected to route-views.routeviews.org.
   User Access Verification
   ...
    
   Username: rviews
   route-views>show ip route 31.173.84.141 255.255.255.255
   % Subnet not in table
   route-views>show bgp 31.173.84.141 255.255.255.255
   % Network not in table
```
 * Сообщения `% Subnet not in table` и `% Network not in table` появились потому что на маршрутизаторе `route-views.routeviews.org` отсутствуют записи маршрутов  c с указанным IP для маски /32
 * Проверим маршруты без указания маски:
 ``` 
    route-views>show ip route 31.173.84.141                
    Routing entry for 31.173.80.0/21
      Known via "bgp 6447", distance 20, metric 0
      Tag 852, type external
      Last update from 154.11.12.212 1w1d ago
      Routing Descriptor Blocks:
      * 154.11.12.212, from 154.11.12.212, 1w1d ago
          Route metric is 0, traffic share count is 1
          AS Hops 3
          Route tag 852
          MPLS label: none
    route-views>
    route-views>show ip bgp 31.173.84.141  
    BGP routing table entry for 31.173.80.0/21, version 1418388713
    Paths: (23 available, best #11, table default)
      Not advertised to any peer
      Refresh Epoch 1
      1351 6939 31133 25159, (aggregated by 25159 10.97.0.225)
        132.198.255.253 from 132.198.255.253 (132.198.255.253)
          Origin IGP, localpref 100, valid, external
          path 7FE139A16630 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      6939 31133 25159, (aggregated by 25159 10.97.0.225)
        64.71.137.241 from 64.71.137.241 (216.218.252.164)
          Origin IGP, localpref 100, valid, external
          path 7FE0CC9AB188 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      20912 3257 174 31133 25159, (aggregated by 25159 10.97.0.225)
        212.66.96.126 from 212.66.96.126 (212.66.96.126)
          Origin IGP, localpref 100, valid, external
          Community: 3257:8070 3257:30155 3257:50001 3257:53900 3257:53902 20912:65004
          path 7FE14E887760 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3333 31133 25159, (aggregated by 25159 10.97.0.225)
        193.0.0.56 from 193.0.0.56 (193.0.0.56)
          Origin IGP, localpref 100, valid, external
          path 7FE015CC6350 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 2
      8283 31133 25159, (aggregated by 25159 10.97.0.225)
     --More-- 
        ...
 ```
 * Можно сразу посмотреть лучший маршрут BGP:
 ```
    route-views>show ip bgp 31.173.84.141 best
    BGP routing table entry for 31.173.80.0/21, version 1418388713
    Paths: (23 available, best #11, table default)
      Not advertised to any peer
      Refresh Epoch 1
      852 31133 25159, (aggregated by 25159 10.97.0.225)
        154.11.12.212 from 154.11.12.212 (96.1.209.43)
          Origin IGP, metric 0, localpref 100, valid, external, best
          path 7FE16B60D488 RPKI State not found
          rx pathid: 0, tx pathid: 0x0
 ```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
### Решение
* Подготовим тестовую среду:
```
    Vagrant.configure("2") do |config|
      config.vm.define "ubuntu01" do |vm1|
        vm1.vm.hostname = "ubuntu01"
        vm1.vm.box = "bento/ubuntu-20.04"
        vm1.vm.network "private_network", ip: "192.168.56.4", virtualbox__intnet: "mynetwork1"
        vm1.vm.network "private_network", ip: "192.168.57.5", virtualbox__intnet: "mynetwork2"
        vm1.vm.provider "virtualbox" do |vb|
          vb.name = "ubuntu01"
          vb.gui = false
          vb.memory = "1024"
        end
      end
      config.vm.define "ubuntu02" do |vm2|
        vm2.vm.hostname = "ubuntu02"
        vm2.vm.box = "bento/ubuntu-20.04"
        vm2.vm.network "private_network", ip: "192.168.56.41", virtualbox__intnet: "mynetwork1"
        vm2.vm.provider "virtualbox" do |vb|
          vb.name = "ubuntu02"
          vb.gui = false
          vb.memory = "1024"
        end
      end
        config.vm.define "ubuntu03" do |vm2|
        vm2.vm.hostname = "ubuntu03"
        vm2.vm.box = "bento/ubuntu-20.04"
        vm2.vm.network "private_network", ip: "192.168.57.51", virtualbox__intnet: "mynetwork2"    
        vm2.vm.provider "virtualbox" do |vb|
          vb.name = "ubuntu03"
          vb.gui = false
          vb.memory = "1024"
        end
      end
    end
```
* Включение модуля dummy:
```
       root@vagrant:~# modprobe dummy
       root@vagrant:~# echo "dummy" >> /etc/modules
       root@ubuntu01:~# lsmod | grep dummy
       dummy                  16384  0
       root@ubuntu01:~# 
```
* Если требуется более одного интерфейса dummy - `echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf`
```
   root@vagrant:~# modprobe -v dummy numdummies=2
   root@vagrant:~# echo "dummy" >> /etc/modules
   root@vagrant:~# echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf
```
* Добавить интерейсы с помощью команды `ip`:
```
   root@vagrant:~# ip link add dummy0 type dummy
   root@vagrant:~# ip link set dev dummy0 up
   root@vagrant:~# ip addr add 172.17.16.1/32 dev dummy0
```
* Создание dummy интерфейса, конфиг для netplan:
```
   root@vagrant:~# cat /etc/netplan/02-dummy.yaml 
   network:
     version: 2
     renderer: networkd
     bridges:
       dummy0:
         dhcp4: no
         dhcp6: no
         accept-ra: no
         interfaces: [ ]
         addresses: [172.17.16.1/32]
   root@vagrant:~# 
```
* Проверим доступность dummy0:
```
    root@ubuntu01:~# ip -br a
    lo               UNKNOWN        127.0.0.1/8 ::1/128 
    eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64 
    eth1             UP             192.168.56.4/24 fe80::a00:27ff:fe61:608f/64 
    eth2             UP             192.168.57.5/24 fe80::a00:27ff:fe0d:33d4/64 
    dummy0           UNKNOWN        172.17.16.1/32 fe80::8020:7aff:fef8:accd/64 
    root@ubuntu01:~# ping 172.17.16.1
    PING 172.17.16.1 (172.17.16.1) 56(84) bytes of data.
    64 bytes from 172.17.16.1: icmp_seq=1 ttl=64 time=0.011 ms
    64 bytes from 172.17.16.1: icmp_seq=2 ttl=64 time=0.046 ms
    64 bytes from 172.17.16.1: icmp_seq=3 ttl=64 time=0.046 ms
    64 bytes from 172.17.16.1: icmp_seq=4 ttl=64 time=0.048 ms
    ^C
    --- 172.17.16.1 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3148ms
    rtt min/avg/max/mdev = 0.011/0.037/0.048/0.015 ms
    root@ubuntu01:~# 
```
* Включим перессылку пакетов на виртуальной машине, которая подключена к двум внутренним сетям:
```
     root@ubuntu01:~# cat /proc/sys/net/ipv4/ip_forward
     0
     root@ubuntu01:~# sysctl -w net.ipv4.ip_forward=1
     net.ipv4.ip_forward = 1
     root@ubuntu01:~# 
```
* Для включения форвардинга пакетов после перезагрузки системы отредактируем опцию `net.ipv4.ip_forward = 1` в файле `/etc/sysctl.conf`
```
    root@ubuntu01:~# vim /etc/sysctl.conf
    ...
    # Uncomment the next line to enable packet forwarding for IPv4
    net.ipv4.ip_forward=1
```
* Настройки на vm ubuntu02:
```
   vagrant@ubuntu02:~$ hostname
   ubuntu02
   vagrant@ubuntu02:~$ ip -br a
   lo               UNKNOWN        127.0.0.1/8 ::1/128 
   eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64 
   eth1             UP             192.168.56.41/24 fe80::a00:27ff:fe42:33b7/64 
   vagrant@ubuntu02:~$ ip -br r
   default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
   10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
   10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
   192.168.56.0/24 dev eth1 proto kernel scope link src 192.168.56.41 
   vagrant@ubuntu02:~$ 
```
* Настройки на vm ubuntu03:
```
    vagrant@ubuntu03:~$ hostname
    ubuntu03
    vagrant@ubuntu03:~$ ip -br a
    lo               UNKNOWN        127.0.0.1/8 ::1/128 
    eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64 
    eth1             UP             192.168.57.51/24 fe80::a00:27ff:fe97:ad09/64 
    vagrant@ubuntu03:~$ ip -br r
    default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
    10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
    192.168.57.0/24 dev eth1 proto kernel scope link src 192.168.57.51 
    vagrant@ubuntu03:~$ 
    
```
* В такой конфигурации виртуальные машины ubuntu02 и ubuntu03 не могут получить доступ к друг другу:
```
   vagrant@ubuntu03:~$ ping 192.168.56.41
   PING 192.168.56.41 (192.168.56.41) 56(84) bytes of data.
   From 10.0.2.2 icmp_seq=9 Destination Net Unreachable
   From 10.0.2.2 icmp_seq=10 Destination Net Unreachable
   From 10.0.2.2 icmp_seq=11 Destination Net Unreachable
   From 10.0.2.2 icmp_seq=12 Destination Net Unreachable
   ^C
   --- 192.168.56.41 ping statistics ---
   12 packets transmitted, 0 received, +4 errors, 100% packet loss, time 12772ms
```
* Добавим статитческие маршруты на виртуальных машинах ubuntu02(192.168.56.41/24) и ubuntu03 (ip 192.168.57.51/24):
```
    vagrant@ubuntu02:~$ sudo ip route add 192.168.57.0/24 via 192.168.56.4
    vagrant@ubuntu02:~$ ip r
    default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
    10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
    192.168.56.0/24 dev eth1 proto kernel scope link src 192.168.56.41 
    192.168.57.0/24 via 192.168.56.4 dev eth1 
    vagrant@ubuntu02:~$ 
    ...
    
    vagrant@ubuntu03:~$ sudo ip route add 192.168.56.0/24 via 192.168.57.5
    vagrant@ubuntu03:~$ ip r
    default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
    10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
    192.168.56.0/24 via 192.168.57.5 dev eth1 
    192.168.57.0/24 dev eth1 proto kernel scope link src 192.168.57.51 
```
* Проверим доступность виртуальной машины ubuntu02(192.168.56.41/24) из вирутальной машины ubuntu03(ip 192.168.57.51/24):
```
    vagrant@ubuntu03:~$ ping 192.168.56.41
    PING 192.168.56.41 (192.168.56.41) 56(84) bytes of data.
    64 bytes from 192.168.56.41: icmp_seq=1 ttl=63 time=0.793 ms
    64 bytes from 192.168.56.41: icmp_seq=2 ttl=63 time=1.01 ms
    64 bytes from 192.168.56.41: icmp_seq=3 ttl=63 time=0.867 ms
    64 bytes from 192.168.56.41: icmp_seq=4 ttl=63 time=0.904 ms
    64 bytes from 192.168.56.41: icmp_seq=5 ttl=63 time=0.772 ms
    ^C
    --- 192.168.56.41 ping statistics ---
    5 packets transmitted, 5 received, 0% packet loss, time 4102ms
    rtt min/avg/max/mdev = 0.772/0.868/1.008/0.084 ms
    vagrant@ubuntu03:~$ traceroute 192.168.56.41
    traceroute to 192.168.56.41 (192.168.56.41), 30 hops max, 60 byte packets
     1  192.168.57.5 (192.168.57.5)  0.697 ms  0.665 ms  0.855 ms
     2  192.168.56.41 (192.168.56.41)  0.842 ms  0.831 ms  0.902 ms
    vagrant@ubuntu03:~$ 
```


3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
### Решение

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
### Решение

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
### Решение

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

 ---
