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
 * Полученный HTTP код: ]Status Code: 307 Internal Redirect`
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
5. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
 ### Решение
7. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
 ### Решение
9. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
 ### Решение
11. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
 ### Решение
13. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`
 ### Решение
