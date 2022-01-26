
## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

### Решение
* Выполненые шаги
```
vagrant@server1:~$ mkdir docker_nginx
vagrant@server1:~$ vim index.html
vagrant@server1:~$ cat index.html 
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ vim Dockerfile
vagrant@server1:~$ cat Dockerfile
FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ docker build -t websrv .
Sending build context to Docker daemon   38.4kB
Step 1/2 : FROM nginx:latest
latest: Pulling from library/nginx
a2abf6c4d29d: Pull complete 
a9edb18cadd1: Pull complete 
589b7251471a: Pull complete 
186b1aaa4aa6: Pull complete 
b4df32aa5a72: Pull complete 
a0bcbecc962e: Pull complete 
Digest: sha256:0d17b565c37bcbd895e9d92315a05c1c3c9a29f762b011a10c54a66cd53c9b31
Status: Downloaded newer image for nginx:latest
 ---> 605c77e624dd
Step 2/2 : COPY ./index.html /usr/share/nginx/html/index.html
 ---> 5265ca22cfc4
Successfully built 5265ca22cfc4
Successfully tagged websrv:latest
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ docker tag websrv:latest seadockerhub/websrv:v0.1
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ docker image ls
REPOSITORY            TAG       IMAGE ID       CREATED              SIZE
websrv                latest    5265ca22cfc4   About a minute ago   141MB
seadockerhub/websrv   v0.1      5265ca22cfc4   About a minute ago   141MB
nginx                 latest    605c77e624dd   3 weeks ago          141MB
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ docker run -it -d -p 8080:80 --name web seadockerhub/websrv:v0.1
b1e4b3fb3fc1d1ff888ac16e48ba9f3b6aaabee1da1a39ae1051a413ad6da93e
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                                   NAMES
b1e4b3fb3fc1   seadockerhub/websrv:v0.1   "/docker-entrypoint.…"   18 seconds ago   Up 17 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   web
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ curl 127.0.0.1:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
vagrant@server1:~$
vagrant@server1:~$ 
vagrant@server1:~$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: seadockerhub
Password: 
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
vagrant@server1:~$ docker push seadockerhub/websrv:v0.1
The push refers to repository [docker.io/seadockerhub/websrv]
45bc42a32466: Pushed 
d874fd2bc83b: Mounted from library/nginx 
32ce5f6a5106: Mounted from library/nginx 
f1db227348d0: Mounted from library/nginx 
b8d6e692a25e: Mounted from library/nginx 
e379e8aedd4d: Mounted from library/nginx 
2edcec3590a4: Mounted from library/nginx 
v0.1: digest: sha256:c78d912d9744c662b548ab5955f89d38b7069b4f7dad933fba29696acd7cda84 size: 1777
vagrant@server1:~$ 
```

* [Ссылка на профиль seadockerhub в hub.docker.com](https://hub.docker.com/u/seadockerhub)

* Команда для скачивания образа
```
docker pull seadockerhub/websrv:v0.1
```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.


### Решение
* - Высоконагруженное монолитное java веб-приложение;
    > Если это монолитное высоконагруженное приложение - лучше   использовать физический сервер или полную аппаратную виртуализацию(например VMWare vCentre). Во-первых - приложение монолитное и не подразумеватся разворачивание в виде микросервисов, во-вторых - чтобы сократить количество различных задержек при больших нагрузках, связанных с многослойной архитектурой (если речь идет например о паравиртуализации), а также уменьшаем количество потенциальных точек отказа.
* - Nodejs веб-приложение;
    > В данной ситуации подходит Docker контейнер, одно приложение - один процесс в контейнер (отвечает принципам миркросервисов). 
* - Мобильное приложение c версиями для Android и iOS;
    > В случае с Andoid можно использовать как Docker так и физическую машину (смартфон), в случае c iOS -только физическое устройство, т.к. лицензия Apple не позволяет виртуализировать iOS в любом виде. 
* - Шина данных на базе Apache Kafka;
    > В виду того, что брокер сообщений Kafka — распределенная система, а его серверы объединяются в кластеры (хранение и пересылка сообщений идет параллельно на разных серверах - это дает надежность и отказоустойчивость) и учитывая, что сервис масштабируется горизонтально, на мой взгляд, здесь подойдет решение на базе микросервисов (в виде Docker контейнеров).
* - Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
    > По причине высоких требований к производительности кластера Elasticsearch, на мой взгляд, для его организации выгоднее использовать либо физические сервера, либо полную аппаратную виртуализацию(например VMWare vCentre). 
* - Мониторинг-стек на базе Prometheus и Grafana;
    > Так как по умочанию Prometheus не рассчитан на длительное хранение данных, а Grafana инструмент для визуализации -  подходит вариант с Docker контейнерами.
* - MongoDB, как основное хранилище данных для java-приложения;
    > На мой взгляд, для данной задачи подойдет как Docker c persistent volume (удобно для управления, например при обновлении версии), так и виртуализация(напр. VMware vSAN). В любом случае придется позаботиться о высокой доступности и отказоуйсточивости "тома" на котором расположится БД.
* - Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
    > Так как (закрытый) Docker Registry - в типовом кейсе разворачивается на базе образа registry (образ содержит реализацию Docker Registry HTTP API V2) c persistent volume, так и для GitLab имеются образы 'gitlab/gitlab-ce' и 'gitlab/gitlab-runner' - на мой взгляд удобно поднять все в контейнерах c persistent volume. По крайней мере это очень быстро и удобно для dev сред.


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.


### Решение
* Выполненые шаги
```
vagrant@server1:~$ mkdir ~/data
vagrant@server1:~$
vagrant@server1:~$
vagrant@server1:~$ docker run -it -d -v ~/data:/data -h "centos" --name centos01 centos
6b95b9623c42b1489992e15591311809360fa038495cab5583323be7819ae536
vagrant@server1:~$
vagrant@server1:~$
vagrant@server1:~$ docker run -it -d -v ~/data:/data -h "debian" --name debian01 debian
acda43a3697ca90c4b45a3da126f78fb2fda019781cbb0082def641293fd4278
vagrant@server1:~$
vagrant@server1:~$
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
acda43a3697c   debian    "bash"        36 seconds ago   Up 36 seconds             debian01
6b95b9623c42   centos    "/bin/bash"   44 seconds ago   Up 43 seconds             centos01
vagrant@server1:~$ 
vagrant@server1:~$
vagrant@server1:~$ docker exec -it centos01 /bin/bash
[root@centos /]# ls
bin   dev  home  lib64	     media  opt   root	sbin  sys  usr
data  etc  lib	 lost+found  mnt    proc  run	srv   tmp  var
[root@centos /]# cd data && echo "Hi from centos" > hi_from_centos.txt
[root@centos data]# ls
hi_from_centos.txt
[root@centos data]# read escape sequence
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ 
vagrant@server1:~$ cd ~/data/ && echo "Hi from host" > hi_from_host.txt 
vagrant@server1:~/data$ cd ~
vagrant@server1:~$ docker exec -it debian01 /bin/bash
root@debian:/# cd /data 
root@debian:/data# ls -la
total 16
drwxrwxr-x 2 1000 1000 4096 Jan 24 20:51 .
drwxr-xr-x 1 root root 4096 Jan 24 20:42 ..
-rw-r--r-- 1 root root   15 Jan 24 20:45 hi_from_centos.txt
-rw-rw-r-- 1 1000 1000   13 Jan 24 20:51 hi_from_host.txt
root@debian:/data# cat *.txt
Hi from centos
Hi from host
root@debian:/data# 
root@debian:/data# read escape sequence
vagrant@server1:~$ 
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


### Решение
* Используем [Dockerfile](https://github.com/easulimov/devops-netology/blob/main/05-virt-03-docker/src/build/ansible/Dockerfile) из практической части лекции
```
vagrant@server1:~$ mkdir docker_ansible
vagrant@server1:~$ cd docker_ansible/
vagrant@server1:~/docker_ansible$ vim Dockerfile
vagrant@server1:~/docker_ansible$ docker build -t seadockerhub/ansible:v2.9.24 .
Sending build context to Docker daemon   2.56kB
Step 1/5 : FROM alpine:3.14
...
...
...
Successfully built b7ec179e63cb
Successfully tagged seadockerhub/ansible:v2.9.24
vagrant@server1:~/docker_ansible$ 
vagrant@server1:~/docker_ansible$ docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED             SIZE
seadockerhub/ansible   v2.9.24   b7ec179e63cb   2 minutes ago       227MB
seadockerhub/websrv    v0.1      5265ca22cfc4   About an hour ago   141MB
...
...
vagrant@server1:~/docker_ansible$ \
vagrant@server1:~/docker_ansible$ docker run -it --name ansible seadockerhub/ansible:v2.9.24
ansible-playbook 2.9.24
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
vagrant@server1:~/docker_ansible$ 
vagrant@server1:~/docker_ansible$ docker login
Authenticating with existing credentials...
...
...
Login Succeeded
vagrant@server1:~/docker_ansible$ docker push seadockerhub/ansible:v2.9.24
The push refers to repository [docker.io/seadockerhub/ansible]
995425d1018e: Pushed 
ee22d1cfddd0: Pushed 
1a058d5342cc: Mounted from library/alpine 
v2.9.24: digest: sha256:46f26e0a0529eb1471189be7f2a96173e485567d919b2f557862d70ce47900ae size: 947
vagrant@server1:~/docker_ansible$ 
```
* [Ссылка на профиль seadockerhub в hub.docker.com](https://hub.docker.com/u/seadockerhub)

* Команда для скачивания образа
```
docker pull seadockerhub/ansible:v2.9.24
```
