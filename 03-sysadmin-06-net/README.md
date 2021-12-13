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
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
 ### Решение
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
 ### Решение
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`
 ### Решение
