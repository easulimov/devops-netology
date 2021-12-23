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
 * Сообщения `% Subnet not in table` и `% Network not in table` появились потому что на маршрутизаторе `route-views.routeviews.org` отсутствуют записи маршрутов для маски /32
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
    route-views>show bgp 31.173.84.141
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
    ...
 ```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
### Решение

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
