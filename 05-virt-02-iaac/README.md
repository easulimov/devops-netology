
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
* - Чем Ansible выгодно отличается от других систем управление конфигурациями?
    > По причине того, что в большинстве случаев на обслуживаемых серверах уже всегда установлен Python и имеется доступ по ssh, первое достоинство Ansible заключается в простоте эксплуатации. Использование Ansible не требуется установки на сервера дополнительного ПО, его можно использовать без PKI инфраструктуры. В виду того что для написания сценарией (playbooks) используется YAML, достигается высокая читаемость выполняемых действий и упрощается документирование.
* - Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
    > Ansible использует метод `Push` - благодаря которому вы самостоятельно гарантируете время внесения изменений в конфигрурацию и сразу же получаете резльтат. На мой взгляд, метод `Pull` в данном контексте менее надежен, т.к. агенты, которые забирают конфигурацию с центральной ноды, запускаются на серверах по таймеру - то есть о результате получится узнать не сразу, а если результат негативный, увеличивается время реакции. На мой взгляд метод `Pull` хорошо себя проявит, только если не отлажено информирование о постоянно разворачивающихся новых серверах в вашей инфраструктуре, которые требуют внесения изменений в конфигруацию. 

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

### Решение:

- **VirtualBox**
* Установка
```
sudo apt update && sudo apt install -y linux-headers-$(uname -r) build-essential dkms \
virtualbox virtualbox-ext-pack vde2 virtualbox-guest-additions-iso
```
* Версия
```
sysadm@pc01:~$ vboxmanage --version
6.1.26_Ubuntur145957
```

- **Vagrant**
* Установка
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
sudo apt-add-repository --yes "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
sudo apt update && sudo apt install -y vagrant
```
* Версия
```
sysadm@pc01:~$ vagrant --version
Vagrant 2.2.19
sysadm@pc01:~$ 
```


- **Ansible**
* Установка
```
sudo apt update && sudo apt install software-properties-common && \
sudo add-apt-repository --yes --update ppa:ansible/ansible && \
sudo apt install -y ansible
```
* Версия
```
sysadm@pc01:~$ ansible --version
ansible [core 2.12.1]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/sysadm/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/sysadm/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
  jinja version = 2.11.3
  libyaml = True
sysadm@pc01:~$ 
```

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
