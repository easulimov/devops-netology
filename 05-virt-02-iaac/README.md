
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
* Предварительно создадим ssh ключи
```
ssh-keygen -t rsa -b 4096 -C "vagrant"
```

```
sysadm@pc01:~/.ssh$ ll id_*
-rw------- 1 sysadm sysadm 3369 янв 23 09:35 id_rsa
-rw-r--r-- 1 sysadm sysadm  733 янв 23 09:35 id_rsa.pub
sysadm@pc01:~/.ssh$ 
```

* Перейдем в директорию, где находится подготовленный `Vagrantfile` и  выполним команду `vagrant up`
```
sysadm@pc01:~/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant$ vagrant up
Bringing machine 'server1.test.local' up with 'virtualbox' provider...
==> server1.test.local: Importing base box 'bento/ubuntu-20.04'...
==> server1.test.local: Matching MAC address for NAT networking...
==> server1.test.local: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.test.local: Setting the name of the VM: server1.test.local
==> server1.test.local: Fixed port collision for 22 => 2222. Now on port 2200.
==> server1.test.local: Clearing any previously set network interfaces...
==> server1.test.local: Preparing network interfaces based on configuration...
    server1.test.local: Adapter 1: nat
    server1.test.local: Adapter 2: hostonly
==> server1.test.local: Forwarding ports...
    server1.test.local: 22 (guest) => 20011 (host) (adapter 1)
    server1.test.local: 22 (guest) => 2200 (host) (adapter 1)
==> server1.test.local: Running 'pre-boot' VM customizations...
==> server1.test.local: Booting VM...
==> server1.test.local: Waiting for machine to boot. This may take a few minutes...
    server1.test.local: SSH address: 127.0.0.1:2200
    server1.test.local: SSH username: vagrant
    server1.test.local: SSH auth method: private key
    server1.test.local: 
    server1.test.local: Vagrant insecure key detected. Vagrant will automatically replace
    server1.test.local: this with a newly generated keypair for better security.
    server1.test.local: 
    server1.test.local: Inserting generated public key within guest...
    server1.test.local: Removing insecure key from the guest if it's present...
    server1.test.local: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.test.local: Machine booted and ready!
==> server1.test.local: Checking for guest additions in VM...
==> server1.test.local: Setting hostname...
==> server1.test.local: Configuring and enabling network interfaces...
==> server1.test.local: Mounting shared folders...
    server1.test.local: /vagrant => /home/sysadm/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant
==> server1.test.local: Running provisioner: ansible...
    server1.test.local: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.test.local]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.test.local]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.test.local]

TASK [Checking DNS] ************************************************************
changed: [server1.test.local]

TASK [Installing tools] ********************************************************
ok: [server1.test.local] => (item=git)
ok: [server1.test.local] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [server1.test.local]

TASK [Add the current user to docker group] ************************************
changed: [server1.test.local]

PLAY RECAP *********************************************************************
server1.test.local         : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sysadm@pc01:~/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant$
```

* Подключимся к ВМ выполнив команду `vagrant ssh` и далее выполним команду `docker ps`
```
sysadm@pc01:~/PycharmProjects/devops-netology/05-virt-02-iaac/src/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun 23 Jan 2022 02:57:05 PM UTC

  System load:  0.0                Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 13%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    115


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Jan 23 14:49:09 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```
* Запустим контейнер "Hello-world" с помощью команды `docker run hello-world`
```
vagrant@server1:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:975f4b14f326b05db86e16de00144f9c12257553bba9484fed41f9b6f2257800
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

vagrant@server1:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
358d5c0d5e2a   hello-world   "/hello"   22 seconds ago   Exited (0) 22 seconds ago             determined_gates
vagrant@server1:~$ 
```
