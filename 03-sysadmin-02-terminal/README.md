1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
    #### Решение:
    Вводим команду - `type -a cd`. Получаем ответ `cd is a shell builtin`. Bash имеет ряд встроенных команд, для увеличения быстродействия их исполнения, т.к. при использовании внешних команд, тратятся дополнительные ресурсы на межпроцессное взаимодействие. Также, при использовании в скриптах, встроенные команды обычно не порождают дочерних процессов. Важно, быть внимательным при использовании, так как часто у внутренних команд имеются одноименные внешние.

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.
    #### Решение:
    `grep -n -i alias .bashrc` - за счет ключа `-n`, к выводу добавятся номера строк.
    
3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
    #### Решение:
    Процесс `systemd` (/sbin/init является символической ссылкой на /lib/systemd/systemd).
    `ps -q 1 -o comm=` - покажет нам **systemd**
    Проверим:
    `ps aux | head -2`
    
    ```
        vagrant@vagrant:~$ ps aux | head -2
        USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
        root           1  0.0  0.5 101664 11304 ?        Ss   10:05   0:00 /sbin/init
    ```
    
    ```
    
    
        vagrant@vagrant:~$ file /sbin/init 
        /sbin/init: symbolic link to /lib/systemd/systemd
        vagrant@vagrant:~$ file /lib/systemd/systemd
        /lib/systemd/systemd: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=78f95f4397ec78232760853bd2e6df3f60ace24b, for GNU/Linux 3.2.0, stripped
	
    ```

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?
    #### Решение:
    `ls -lah /root 2>/dev/pts/1`
    * Терминал 1:
      ```
          vagrant@vagrant:~$ tty
          /dev/pts/0
          vagrant@vagrant:~$ ls -lah /root 2>/dev/pts/1
          vagrant@vagrant:~$    
      ```
    * Терминал 2:
      ```
          vagrant@vagrant:~$ tty
          /dev/pts/1
          vagrant@vagrant:~$ ls: cannot open directory '/root': Permission denied
      ```
5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
    #### Решение:
    ```
        vagrant@vagrant:~$ wc -l < /etc/passwd > users_count.txt
        vagrant@vagrant:~$ cat users_count.txt 
        35
        vagrant@vagrant:~$ 
    ```
6. Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
    #### Решение:
    * Сворачиваем  терминал(`vagrant ssh`) и открываем GUI VirtualBox. Для примера меняем TTY на TTY5 с помощью сочетаний клавиш (выполняю на MacBook): `fn+control+command+F5` и логинимся под пользователем `vagrant`. Возвращаемся в терминал(`vagrant ssh`) и направляем `echo "Hello from pts/0" > /dev/tty5`. Смотрим на  полученное сообщение `"Hello from pts/0"`
    * Чтобы отправить сообщение на любой из имеющихся `tty`, без предворительного логина под тем же пользователем, требуется доступ от имени `root` (`sudo -i` и далее перенаправляем вывод команды `echo`)
    * В реальной ситуации, при условии локального подключения к хосту с Ubuntu, находясь в графическом окружении (`graphical.target`) - **наблюдать выводимые данные не получится**, до переключения на требуемый TTY сочетанием клавиш `CTRL+ALT+F{1-6}`. Чтобы вернуться обратно в графический интерфейс:`CTRL+ALT+F7`
7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
    #### Решение:
    * Команда `bash 5>&1` - создает новый сеанс bash (подоболочку) и связывает файловый дескриптор 5 с stdout (вывод дескриптора 5 направляется в дескриптор 1)
    * `echo netology > /proc/$$/fd/5` - выводит "netology" на экран
    * Команда bash 5>&1 связала с дескриптором под номером 5 стандартный поток вывода вызванной подоболочки bash. Теперь, для запущенного сеанса bash, файловые дескрипторы 1 и 5 связаны с /dev/pts/0. До тех пор, пока мы не выйдем из текущего сеанса `bash` - можно направлять с помощью `>` на /proc/$$/fd/5 вывод различных команд, и он будет отображаться в окне терминала.
    * P.S. Если мы запустим еще одну подоболочку, файловый дескриптор с номером 5 будет унаследован, и мы вновь сможем выполнить `echo netology > /proc/$$/fd/5`
    * Пример:
    ```
           vagrant@vagrant:~$ echo $$
           1341
           vagrant@vagrant:~$ ls -lahF /proc/1341/fd/5
           ls: cannot access '/proc/1341/fd/5': No such file or directory
           vagrant@vagrant:~$ ls -lahF /proc/1341/fd/1
           lrwx------ 1 vagrant vagrant 64 Nov 21 17:02 /proc/1341/fd/1 -> /dev/pts/0
           vagrant@vagrant:~$ bash 5>&1
           vagrant@vagrant:~$ echo $$
           1350
           vagrant@vagrant:~$ ls -lahF /proc/1350/fd/5
           lrwx------ 1 vagrant vagrant 64 Nov 21 17:03 /proc/1350/fd/5 -> /dev/pts/0
           vagrant@vagrant:~$ echo "Hello from PID 1350" > /proc/$$/fd/5
           Hello from PID 1350
           vagrant@vagrant:~$ exit
           vagrant@vagrant:~$ echo $$
           1341
           vagrant@vagrant:~$ ls -lahF /proc/1350/fd/5
           ls: cannot access '/proc/1350/fd/5': No such file or directory    
    ```
    
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
    #### Решение:
    ```
    
        vagrant@vagrant:~$ find / -name .bashrc 3>&2 2>&1 1>&3 | wc -l
        /home/vagrant/.bashrc
        /etc/skel/.bashrc
        771
    ```
    * Новый дескриптор 3 связали (перенаправили вывод)  со стандартным потоком ошибок у которго номер 2 - `3>&2` 
    * Cтандартный поток ошибок 2 связали со стандартным потоком вывода 1 - `2>&1`
    * Стандартный поток вывода 1 связали с дескриптором 3 - `1>&3`
    Таким образом, с помощью дескриптора 3 выполнена замена потоков. Вывод stderr передан в на stdin `wc -l` результатом 771. При этом сохранен вывод на pty `/home/vagrant/.bashrc` и `/etc/skel/.bashrc`
    
9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
    #### Решение:
    * Команда `cat /proc/$$/environ` - вывела переменные окружения
    * Аналогичный вывод, в отформатированном виде можно получить с помощью `printenv`

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
    #### Решение:
    `man 5 proc`
    * `/proc/<PID>/cmdline` -  Этот доступный только для чтения файл содержит полную командную строку для процесса, если только процесс не является зомби. В последнем случае в этом файле ничего нет: то есть чтение этого файла вернет 0 символов. Аргументы командной строки появляются в этом файле в виде набора строк, разделенных нулевыми байтами ('\ 0'), с последующим нулевым байтом после последней строки.
      * Например, обратим внимание на поле CMD в выводе.
       
      ```
          USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
          root           1  0.0  0.5 101804 11100 ?        Ss   16:26   0:00 /sbin/init
          root           2  0.0  0.0      0     0 ?        S    16:26   0:00 [kthreadd]
	  ...
	  root         395  0.0  0.2  21076  5068 ?        Ss   16:26   0:00 /lib/systemd/systemd-udevd
          systemd+     401  0.0  0.3  26604  7632 ?        Ss   16:26   0:00 /lib/systemd/systemd-networkd
	  ...
	  vagrant     1864  0.0  0.4  18384  9332 ?        Ss   18:40   0:00 /lib/systemd/systemd --user
          vagrant     1865  0.0  0.1 103032  3276 ?        S    18:40   0:00 (sd-pam)
          root        1869  0.0  0.0      0     0 ?        I    18:40   0:00 [kworker/1:3]
          vagrant     1899  0.0  0.3  13952  6256 ?        R    18:40   0:00 sshd: vagrant@pts/0
          vagrant     1900  0.0  0.2   9836  4144 pts/0    Ss   18:40   0:00 -bash
          vagrant     1955  0.0  0.1  11492  3416 pts/0    R+   18:56   0:00 ps aux
      ``` 
      * А теперь посмотрим примеры вывода `/proc/<PID>/cmdline` подставляя PID
      ```
          vagrant@vagrant:~$ cat /proc/1/cmdline 
          /sbin/initvagrant@vagrant:~$ cat /proc/1899/cmdline 
          sshd: vagrant@pts/0vagrant@vagrant:~$ cat /proc/1900/cmdline 
          -bashvagrant@vagrant:~$ 
      ``` 
      * По сути `/proc/<PID>/cmdline` содержит информацию об исполняемых файлах процесса
      
    * `/proc/<PID>/exe`- В Linux 2.2 и более поздних версиях этот файл представляет собой символическую ссылку, содержащую фактический путь к исполняемой команде. Эту символическую ссылку можно разыменовать обычным образом; попытка открыть его откроет исполняемый файл.
      * Например:
       
      ```
         vagrant@vagrant:~$ sudo ls -l /proc/1/exe
         lrwxrwxrwx 1 root root 0 Nov 21 15:39 /proc/1/exe -> /usr/lib/systemd/systemd
         vagrant@vagrant:~$ sudo ls -l /proc/1899/exe
         lrwxrwxrwx 1 root root 0 Nov 21 19:09 /proc/1899/exe -> /usr/sbin/sshd
         vagrant@vagrant:~$ sudo ls -l /proc/1900/exe
         lrwxrwxrwx 1 vagrant vagrant 0 Nov 21 18:41 /proc/1900/exe -> /usr/bin/bash
         vagrant@vagrant:~$ 
         
      ```        

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.
    #### Решение:
    * Процессор поддерживает `sse4_2`
    ``` 
         vagrant@vagrant:~$ grep sse /proc/cpuinfo
         flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc          rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor          lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase avx2 invpcid rdseed clflushopt md_clear flush_l1d arch_capabilities
         flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc          rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor          lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase avx2 invpcid rdseed clflushopt md_clear flush_l1d arch_capabilities   
    ```

12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

    Почитайте, почему так происходит, и как изменить поведение.
    #### Решение:
    * В данном примере получается, что в внутри сессии ssh, в рамках которой выполнено подключение к вирутальной машине мы запускаем новую сессию ssh вместе с командой `tty`. По умолчанию, когда запускается команда на удаленном компьютере с помощью ssh, TTY не выделяется для удаленного сеанса. Поэтому возникает ошибка. Чтобы переопределить поведение, нужно использовать ключ `-t` (**-t** - Переназначение псевдо-терминала. Это может быть использовано для произвольного выполнения программ базирующихся на выводе изображения на удаленной машине, что может быть очень полезно, например, при реализации возможностей меню. Несколько параметров -t заданных подряд переназначат терминал, даже если ssh не имеет локального терминала). 
    ```
       vagrant@vagrant:~$ ssh -t localhost "tty"
       vagrant@localhost's password: 
       /dev/pts/1
       Connection to localhost closed.
       vagrant@vagrant:~$     
    ```

    
13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
    #### Решение:

14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.
    #### Решение:

