1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?
 ### Решение
 * Выполнили запрос:
 ```
    vagrant@vagrant:~$ telnet stackoverflow.com 80
    Trying 151.101.65.69...
    Connected to stackoverflow.com.
    Escape character is '^]'.
    GET /questions HTTP/1.0                                                 
    HOST: stackoverflow.com 
    
    HTTP/1.1 301 Moved Permanently
    cache-control: no-cache, no-store, must-revalidate
    location: https://stackoverflow.com/questions
    x-request-guid: 8d49518c-5672-46ea-b297-7b1fcbde2f8f
    feature-policy: microphone 'none'; speaker 'none'
    content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
    Accept-Ranges: bytes
    Date: Mon, 13 Dec 2021 14:45:04 GMT
    Via: 1.1 varnish
    Connection: close
    X-Served-By: cache-hhn4036-HHN
    X-Cache: MISS
    X-Cache-Hits: 0
    X-Timer: S1639406705.534936,VS0,VE85
    Vary: Fastly-SSL
    X-DNS-Prefetch-Control: off
    Set-Cookie: prov=b80d884d-bdab-efa6-2e2c-787a3eab26a6; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

    Connection closed by foreign host.
    vagrant@vagrant:~$ 

 ```
 * Полученный код `301 Moved Permanently` — означает редирект на другой адрес. Запрошенный документ был окончательно перенесен на новый URI, указанный в поле Location заголовка. Адрес на который выполняется редирект `https://stackoverflow.com/questions`.
 
 
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.
 ### Решение
 * Полученный HTTP код: `Status Code: 307 Internal Redirect`
 * Дольше всего обрабатывался запрос GET:
 ```
    Request URL: https://stackoverflow.com/
    Request Method: GET
    Status Code: 200 
    Remote Address: 151.101.1.69:443
    Referrer Policy: strict-origin-when-cross-origin
 ```
 * [Скриншот: Get Request Code 200 Headers](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-06-net/img/Get%20Request%20Status%20Code%20200%20.png)
 * [Скриншот: Request Time](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-06-net/img/Get%20Request%20Time.png)
 
3. Какой IP адрес у вас в интернете?
 ### Решение
 * Используем curl
 ```
    vagrant@vagrant:~$ curl ifconfig.me
    178.176.76.155vagrant@vagrant:~$ 
    vagrant@vagrant:~$ curl ipinfo.io/ip
    178.176.76.155vagrant@vagrant:~$ 
 ```
 * Проверим через сайт `https://whoer.net/ru` [Скриншот](https://raw.githubusercontent.com/easulimov/devops-netology/main/03-sysadmin-06-net/img/My%20Public%20IP.png)
 
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
 ### Решение
 ```
 
    vagrant@vagrant:~$ sudo apt install whois
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following NEW packages will be installed:
      whois
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 44.7 kB of archives.
    After this operation, 279 kB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 whois amd64 5.5.6 [44.7 kB]
    Fetched 44.7 kB in 1s (78.4 kB/s)
    Selecting previously unselected package whois.
    (Reading database ... 74894 files and directories currently installed.)
    Preparing to unpack .../archives/whois_5.5.6_amd64.deb ...
    Unpacking whois (5.5.6) ...
    Setting up whois (5.5.6) ...
    Processing triggers for man-db (2.9.1-1) ...
    vagrant@vagrant:~$ whois 178.176.76.155
    % This is the RIPE Database query service.
    % The objects are in RPSL format.
    %
    % The RIPE Database is subject to Terms and Conditions.
    % See http://www.ripe.net/db/support/db-terms-conditions.pdf

    % Note: this output has been filtered.
    %       To receive output for a database update, use the "-B" flag.
    
    % Information related to '178.176.64.0 - 178.176.95.255'

    % Abuse contact for '178.176.64.0 - 178.176.95.255' is 'abuse-mailbox@megafon.ru'

    inetnum:        178.176.64.0 - 178.176.95.255
    netname:        MF-GNOC-STF-20180202
    descr:          Metropolitan branch of OJSC MegaFon AS25159 178.176.64.0/19
    country:        RU
    org:            ORG-OM1-RIPE
    admin-c:        MFMS-RIPE
    tech-c:         MFMS-RIPE
    status:         ASSIGNED PA
    mnt-by:         MEGAFON-RIPE-MNT
    mnt-lower:      MEGAFON-AUTO-MNT
    mnt-lower:      MF-MOSCOW-MNT
    mnt-routes:     MF-MOSCOW-MNT
    mnt-domains:    MF-MOSCOW-MNT
    created:        2018-10-16T11:01:59Z
    last-modified:  2019-11-29T11:09:03Z
    source:         RIPE

    organisation:   ORG-OM1-RIPE
    org-name:       PJSC MegaFon
    country:        RU
    org-type:       LIR
    address:        41, Oruzheyniy lane
    address:        127006
    address:        Moscow
    address:        RUSSIAN FEDERATION
    phone:          +74955077777
    phone:          +74959801970
    fax-no:         +74959801939
    fax-no:         +74959801949
    admin-c:        MFON-RIPE
    tech-c:         MFON-RIPE
    abuse-c:        MFON-RIPE
    mnt-by:         RIPE-NCC-HM-MNT
    mnt-by:         MEGAFON-RIPE-MNT
    mnt-ref:        RIPE-NCC-HM-MNT
    mnt-ref:        MEGAFON-RIPE-MNT
    created:        2004-04-17T11:55:06Z
    last-modified:  2020-12-16T12:48:00Z
    source:         RIPE # Filtered
    
    role:           Moscow Branch of PJSC MegaFon Internet Center
    address:        41 Oruzheyniy lane, Moscow, Russia, 127006
    admin-c:        IK9000-RIPE
    admin-c:        MFON-RIPE
    tech-c:         IK9000-RIPE
    tech-c:         MFON-RIPE
    nic-hdl:        MFMS-RIPE
    mnt-by:         MF-MOSCOW-MNT
    mnt-by:         MEGAFON-GNOC-MNT
    mnt-by:         MEGAFON-WEST-MNT
    mnt-by:         MEGAFON-RIPE-MNT
    created:        2008-03-25T13:13:46Z
    last-modified:  2019-11-06T11:53:19Z
    source:         RIPE # Filtered
    
    % Information related to '178.176.64.0/19AS25159'
    
    route:          178.176.64.0/19
    descr:          MF-MOSCOW-NAT-POOL-178-176-64-0
    origin:         AS25159
    remarks:
    mnt-by:         MF-MOSCOW-MNT
    mnt-by:         MEGAFON-AUTO-MNT
    created:        2018-10-09T06:47:56Z
    last-modified:  2019-11-18T07:11:57Z
    source:         RIPE
    
    % This query was served by the RIPE Database Query Service version 1.102.1 (ANGUS)
    
    
    vagrant@vagrant:~$ 
 ```
 * Провайдер Мегафон: `org-name: PJSC MegaFon`, автономная система: `AS25159`
 
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
 ### Решение
 ```
     vagrant@vagrant:~$ traceroute -An 8.8.8.8
     traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
      1  10.0.2.2 [*]  0.168 ms  0.139 ms  0.123 ms
      2  192.168.8.1 [*]  14.101 ms  14.595 ms  15.670 ms
      3  * * *
      4  * * *
      5  * * *
      6  * * *
      7  * * *
      8  * * *
      9  * * *
     10  * * *
     11  * * *
     12  * * *
     13  * * *
     14  * * *
     15  209.85.168.98 [AS15169]  61.252 ms 178.176.133.15 [AS31133]  59.755 ms 209.85.168.98 [AS15169]  60.285 ms
     16  108.170.250.130 [AS15169]  61.837 ms 108.170.250.66 [AS15169]  64.057 ms 108.170.250.113 [AS15169]  61.344 ms
     17  172.253.66.116 [AS15169]  62.649 ms 142.250.239.64 [AS15169]  50.438 ms 172.253.66.116 [AS15169]  62.127 ms
     18  72.14.235.69 [AS15169]  59.470 ms 74.125.253.109 [AS15169]  58.377 ms 108.170.235.64 [AS15169]  61.223 ms
     19  142.250.210.103 [AS15169]  76.922 ms 142.250.238.179 [AS15169]  58.776 ms 142.250.57.7 [AS15169]  58.975 ms
     20  * * *
     21  * * *
     22  * * *
     23  * * *
     24  * * *
     25  * * *
     26  * * *
     27  * * *
     28  * * *
     29  8.8.8.8 [AS15169]  82.300 ms  55.887 ms  43.396 ms
     vagrant@vagrant:~$ 
 ```
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
 ### Решение
 * `mtr -zn 8.8.8.8`
 ```
                                     My traceroute  [v0.93]
    vagrant (10.0.2.15)                                            2021-12-13T17:13:09+0000
    Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                   Packets               Pings
     Host                                        Loss%   Snt   Last   Avg  Best  Wrst StDev
     1. AS???    10.0.2.2                         0.0%    43    0.2   0.3   0.2   0.5   0.1
     2. AS???    192.168.8.1                      2.3%    43    5.8   3.4   2.2   8.1   1.3
     3. (waiting for reply)
     4. (waiting for reply)
     5. (waiting for reply)
     6. (waiting for reply)
     7. (waiting for reply)
     8. (waiting for reply)
     9. (waiting for reply)
    10. (waiting for reply)
    11. (waiting for reply)
    12. AS31133  83.149.11.244                    0.0%    42   38.7  41.4  30.7  74.0   7.8
    13. (waiting for reply)
    14. (waiting for reply)
    15. AS31133  178.176.133.15                   0.0%    42   33.5  42.2  29.8  79.0   8.8
    16. AS15169  108.170.250.146                  0.0%    42   36.6  45.4  24.3  72.0  12.2
    17. AS15169  142.251.71.194                  43.9%    42   73.3  62.3  48.7  84.9   9.5
    18. AS15169  216.239.48.224                   0.0%    42   52.2  57.6  45.9  92.3   9.9
    19. AS15169  172.253.70.49                    0.0%    42   57.8  70.0  51.7 179.7  19.0
    20. (waiting for reply)

 ```
 * Наибольшая задержка на хопе 19 (исходя из информации в столбцах Avg и Wrst)`19. AS15169  172.253.70.49    0.0%    42   57.8  70.0  51.7 179.7  19.0`

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
 ### Решение
 * Записи NS (DNS сервера)
 ```
     vagrant@vagrant:~$ dig -t NS dns.google
     
     ; <<>> DiG 9.16.1-Ubuntu <<>> -t NS dns.google
     ;; global options: +cmd
     ;; Got answer:
     ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 25619
     ;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1
     
     ;; OPT PSEUDOSECTION:
     ; EDNS: version: 0, flags:; udp: 65494
     ;; QUESTION SECTION:
     ;dns.google.			IN	NS

     ;; ANSWER SECTION:
     dns.google.		2891	IN	NS	ns1.zdns.google.
     dns.google.		2891	IN	NS	ns3.zdns.google.
     dns.google.		2891	IN	NS	ns2.zdns.google.
     dns.google.		2891	IN	NS	ns4.zdns.google.
     
     ;; Query time: 75 msec
     ;; SERVER: 127.0.0.53#53(127.0.0.53)
     ;; WHEN: Mon Dec 13 17:40:40 UTC 2021
     ;; MSG SIZE  rcvd: 116
 ```
 
 * Записи А
 
 ```
     
     vagrant@vagrant:~$ dig -t A dns.google
     
     ; <<>> DiG 9.16.1-Ubuntu <<>> -t A dns.google
     ;; global options: +cmd
     ;; Got answer:
     ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 951
     ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
     
     ;; OPT PSEUDOSECTION:
     ; EDNS: version: 0, flags:; udp: 65494
     ;; QUESTION SECTION:
     ;dns.google.			IN	A

     ;; ANSWER SECTION:
     dns.google.		430	IN	A	8.8.8.8
     dns.google.		430	IN	A	8.8.4.4
     
     ;; Query time: 0 msec
     ;; SERVER: 127.0.0.53#53(127.0.0.53)
     ;; WHEN: Mon Dec 13 17:40:47 UTC 2021
     ;; MSG SIZE  rcvd: 71

     vagrant@vagrant:~$ 
 
 ```
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`
 ### Решение
 ```
 
    vagrant@vagrant:~$ dig -x 8.8.8.8 | grep PTR
    ;8.8.8.8.in-addr.arpa.		IN	PTR
    8.8.8.8.in-addr.arpa.	4744	IN	PTR	dns.google.
    vagrant@vagrant:~$ dig -x 8.8.4.4 | grep PTR
    ;4.4.8.8.in-addr.arpa.		IN	PTR
    4.4.8.8.in-addr.arpa.	6878	IN	PTR	dns.google.
    vagrant@vagrant:~$ 
 ```
