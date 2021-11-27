1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
    ### Решение:
    * `cd` выполняет системный вызов `chdir("/tmp")` 
    * Зная заранее, за что отвечат конкретный системный вызов, можно сделать так:
        ```
            vagrant@vagrant:~$ strace -fe chdir /bin/bash -c 'cd /tmp'
            chdir("/tmp")                           = 0
            +++ exited with 0 +++
            vagrant@vagrant:~$ 
        ```
    * Список системных вызовов можно посмотреть с помощью `man 2 syscalls`

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
    ### Решение:
    * База `file` находится в `/usr/share/misc/magic.mgc` (cтрока 20 в выводе команды):
        ```
            vagrant@vagrant:~$ strace -fe open,openat,read,write,execve file /dev/tty > strace.test 2>&1 && nl strace.test 
                 1	execve("/usr/bin/file", ["file", "/dev/tty"], 0x7fff8e097018 /* 24 vars */) = 0
                 2	openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
                 3	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
                 4	read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 N\0\0\0\0\0\0"..., 832) = 832
                 5	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
                 6	read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360q\2\0\0\0\0\0"..., 832) = 832
                 7	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
                 8	read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\3003\0\0\0\0\0\0"..., 832) = 832
                 9	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
                10	read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@\"\0\0\0\0\0\0"..., 832) = 832
                11	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
                12	read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\"\0\0\0\0\0\0"..., 832) = 832
                13	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
                14	read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220\201\0\0\0\0\0\0"..., 832) = 832
                15	openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
                16	openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
                17	openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
                18	read(3, "# Magic local data for file(1) c"..., 4096) = 111
                19	read(3, "", 4096)                       = 0
                20	openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
                21	openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
                22	write(1, "/dev/tty: character special (5/0"..., 34/dev/tty: character special (5/0)
                23	) = 34
                24	+++ exited with 0 +++
            vagrant@vagrant:~$ 
        ```
    
    
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
    ### Решение:
    * Сэмулируем данную ситуацию, создав в одном терминале файл `test.txt`с помощью `vim`,  и удалим его в другом терминале. В итоге получим:
       ``` 
           vagrant@vagrant:~$ lsof -nP | grep '(deleted)'
           vim       4742                       vagrant    4u      REG              253,0    12288     131094 /home/vagrant/.test.txt.swp (deleted)
           vagrant@vagrant:~$ 
           vagrant@vagrant:~$ lsof /home/vagrant/.test.txt.swp
           lsof: status error on /home/vagrant/.test.txt.swp: No such file or directory
           ...
       ```
     * Чтобы обнулить файл можно выполнить команду `echo " " > /proc/4742/fd/4`
       ```       
          vagrant@vagrant:~$ lsof -nP | grep '(deleted)'
          vim       4742                       vagrant    4u      REG              253,0        2     131094 /home/vagrant/.test.txt.swp (deleted)
          vagrant@vagrant:~$ 
       ```
     * Обратим внимание на поле `SIZE/OFF`(размер файла в байтах) в выводе `lsof` после `echo " " > /proc/4742/fd/4`, изначально было `12288`, а стало `2`;

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
    ### Решение:
    * Процесс **зомби**  - не будет занимать какие либо ресурсы, а только остается висеть строкой в таблице процессов ядра.
    * Если же процесс **сирота**, родительский процесс которого завершен, ресурсы будут расходоваться, до тех пор, пока процесс init(PID=1) не выполнит wait() для процесса **"сироты"**

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
    ### Решение:    
    
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
    ### Решение:

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
    ### Решение:   
    
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
    ### Решение:  

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
    ### Решение:
 
