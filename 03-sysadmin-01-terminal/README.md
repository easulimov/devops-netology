1. Установите средство виртуализации Oracle VirtualBox.
   ### Решение:
   * sudo apt update
   * sudo apt install virtualbox
   * sudo apt install virtualbox-ext-pack -y
   
2. Установите средство автоматизации Hashicorp Vagrant.
   ### Решение:
   * https://www.vagrantup.com/downloads
   * curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   * sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   * sudo apt-get update && sudo apt-get install vagrant
   * vargant --version

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:
   * iTerm2 в Mac OS X
   * Windows Terminal в Windows
   * выбрать цветовую схему, размер окна, шрифтов и т.д.
   
     #### Решение:
     * Изменена цветовая схема (Terminal - Preferences). [Скриншот](https://github.com/easulimov/devops-netology/blob/da9bf404029e694d88c0acffa87a56d2e41bcd16/03-sysadmin-01-terminal/img/Terminal.%20New%20profile.png)
   * почитать о кастомизации PS1/применить при желании.
     #### Решение:
     * Изменена $PS1 для пользователя root-  export PS1="\e[0;31m\u\e[m@\h\[😎\[:\w# " 
     * Добавлена строчка PS1="\e[0;31m\u\e[m@\h\[😎\[:\w# " в /root/.bashrc, чтобы изменить приглашение при следующих входах.
     
4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
   * Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните **vagrant init**. 
   * Замените содержимое **Vagrantfile** по умолчанию следующим:
     >  
     ```Vagrant.configure("2") do |config|
     	     config.vm.box = "bento/ubuntu-20.04"
     ```end
   * Выполнение в этой директории **vagrant up** установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.
   * **vagrant suspend** выключит виртуальную машину с сохранением ее состояния 
    (т.е., при следующем vagrant up будут запущены все процессы внутри, которые рабоотали на момент вызова suspend), 
   * **vagrant halt** выключит виртуальную   машину штатным образом.
   

