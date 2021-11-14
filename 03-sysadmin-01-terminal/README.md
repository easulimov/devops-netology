1. Установите средство виртуализации Oracle VirtualBox.
        sudo apt update
        sudo apt install virtualbox
        sudo apt install virtualbox-ext-pack -y
2. Установите средство автоматизации Hashicorp Vagrant.
        https://www.vagrantup.com/downloads
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt-get update && sudo apt-get install vagrant

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:
   * iTerm2 в Mac OS X
   * Windows Terminal в Windows
   * выбрать цветовую схему, размер окна, шрифтов и т.д.
   * почитать о кастомизации PS1/применить при желании.

