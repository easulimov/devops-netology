
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
* Выполненные шаги
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

* [Ссылка на профиль в hub.docker.com](https://hub.docker.com/u/seadockerhub)

* Комада для скачивания образа
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

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


### Решение
