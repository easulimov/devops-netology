---

## Задача 1

Создать собственный образ операционной системы с помощью Packer.

Для получения зачета, вам необходимо предоставить:
- Скриншот страницы, как на слайде из презентации (слайд 37).


### Решение:

- Подготовительные шаги:
  * Установка утилиты `yc`
  ```commandline
  curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
  ```
  * Инициализация в `yandex cloud`
  ```commandline
  yc init
  ``` 
  * Проверка созданной конфигурации:
  ```commandline
  yc config list
  ```
  * Получить информацию о текущих параметрах профиля
  ```commandline
  yc config profile list
  ```
  * Получить подробную информацию о профиле
  ```commandline
  yc config profile get netology-sea
  ```
  * Инициализация сети 
  ```commandline
  yc vpc network create --name net --labels my-label=netology-sea --description "my first network via yc"
  ```
  * Создание подсети
  ```commandline
  yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"
  ```
  * Просмотр конфигурации сети
  ```commandline
   yc vpc network list
  ```
    * Просмотр конфигурации сети в YAML формате
  ```commandline
   yc vpc network list --format yaml
  ```
  * Просмотр подсетей
  ```commandline
   yc vpc network list-subnets net
  ```
---
  * Установка `packer`
  ```commandline
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  sudo apt-get update && sudo apt-get install packer
  ```
  * Сборка образа
  ```commandline
  packer build centos-7-base.json
  ``` 
  * Просмотр доступных образов
  ```commandline
  yc compute image list
  ```
  * Удаление образа
  ```commandline
  yc compute image delete --name centos-7-base
  ```
  * Удаление сети и подсети
  ```commandline
  yc vpc subnet delete my-subnet-a && yc vpc network delete net
  ```
  * Переключение на профиль `default` и удаление профиля `netology-sea`
 ```commandline
  yc config profile activate default && yc config profile delete netology-sea
 ```
 * Получить список каталогов
 ```commandline
  yc resource-manager folder list
 ```
 * Удалить каталог
 ```commandline
   yc resource-manager folder delete netology-sea
 ```

## Задача 2

Создать вашу первую виртуальную машину в Яндекс.Облаке.

Для получения зачета, вам необходимо предоставить:
- Скриншот страницы свойств созданной ВМ, как на примере ниже:

<p align="center"> 
  <img width="1200" height="600" src="./assets/yc_01.png">
</p>


### Решение:

 * Установка `terraform`
  ```commandline
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  sudo apt-get update && sudo apt-get install terraform
  ```


## Задача 3

Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить:
- Скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже
<p align="center"> 
<img width="1200" height="600" src="./assets/yc_02.png"> 
</p>


### Решение:



## Задача 4 (*)

Создать вторую ВМ и подключить её к мониторингу развёрнутому на первом сервере.

Для получения зачета, вам необходимо предоставить:
- Скриншот из Grafana, на котором будут отображаться метрики добавленного вами сервера.


### Решение:
