
## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

### Решение:
*
*

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

### Решение:
*
*

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

### Решение:

- VirtualBox
```
sudo apt update && sudo apt install -y linux-headers-$(uname -r) build-essential dkms \
virtualbox virtualbox-ext-pack vde2 virtualbox-guest-additions-iso
```
   * 
- Vagrant
   * https://www.vagrantup.com/downloads
   * curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   * sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   * sudo apt update && sudo apt install vagrant
   * vargant --version

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```


### Решение:
*
*
