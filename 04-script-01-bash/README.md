

## Обязательные задания

1. Есть скрипт:
	```bash
	a=1
	b=2
	c=a+b
	d=$a+$b
	e=$(($a+$b))
	```
	* Какие значения переменным c,d,e будут присвоены?
	* Почему?
 ### Решение:
 ```
     root@vagrant:~# a=1
     root@vagrant:~# b=2
     root@vagrant:~# c=a+b
     root@vagrant:~# d=$a+$b
     root@vagrant:~# e=$(($a+$b))
     root@vagrant:~# echo $c
     a+b
     root@vagrant:~# echo $d
     1+2
     root@vagrant:~# echo $e
     3
     root@vagrant:~# 
 ```
 * Значение переменной `с` равно `a+b`, так как мы не обращаемся к значению каждой переменной с помощью `$` и интерпретатор воспринимает все после знака `=` как  строку;
 * Значение переменной `d` равно `1+2`, потому что мы получем значение каждой переменной с помощью `$`, но в виду того, что мы не используем скобки или `let`, а также явно не указали интерпретатору с помощью `declare -i`, что значения переменных `a` и `b` это числа, то интерпретатор воспринимает все что после знака `=` как строку;
 * Значение переменной `d` равно `3`, так как происходит обращение к значениям каждой переменной, а с помощью конструкции `$(())` bash понимает, что следует выполнить арифметическую операцию сложения.
 
2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
	```bash
	while ((1==1)
	do
	curl https://localhost:4757
	if (($? != 0))
	then
	date >> curl.log
	fi
	done
	```
 ### Решение:
 ```
     root@vagrant:~# vim check_srv.sh 
     root@vagrant:~# ./check_srv.sh 
     curl: (7) Failed to connect to localhost port 4757: Connection refused
     curl: (7) Failed to connect to localhost port 4757: Connection refused
     curl: (7) Failed to connect to localhost port 4757: Connection refused
     ^C
     root@vagrant:~# cat curl.log 
     
     Tue 04 Jan 2022 01:12:25 PM UTC
     Tue 04 Jan 2022 01:12:35 PM UTC
     Tue 04 Jan 2022 01:12:45 PM UTC
     root@vagrant:~# cat check_srv.sh | nl
          1	#!/usr/bin/env bash
          2	while ((1==1))
          3	do
          4	curl https://localhost:4757
          5	if (($?!=0))
          6	then
          7	    date >> curl.log
          8	    sleep 10
          9	else
         10	    echo "Service is available" $(date) >> curl.success.log	
         11	    break
         12	fi
         13	done
     root@vagrant:~# 

 ```
 * Исправления в скрипте: `строка 2` - добавлена вторая закрывающая скобка, `строка 2`- удалены все лишние пробелы внутри `$(( ))`, `строка 8` - добавлена команда `sleep 10`, чтобы выполнять проверки раз в 10 секунд (дисковое пространство будет сокращаться гораздо медленнее), `строка 11` - добавлен `breake` - чтобы прекратить проверки, когда сервис станет доступен.

3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.
 ### Решение:
 ```
     #!/usr/bin/env bash
     declare -i attempts
     addresses_ipv4=("192.168.0.1" "173.194.222.113" "87.250.250.242")
      echo "Ports checking is started"
         for address in ${addresses_ipv4[@]}
         do
     	     attempts=5
             while (($attempts>0))
             do
     	         nc -z -v -w 5 $address 80  &>>log
	         if [ $? != 0 ]
                 then
		     echo "$(date) ${address}:80 is unavailable" >> log
		 else
		     echo $(date) >> log
          	 fi	    
                 ((attempts-=1))
            done
        done
      echo "Port checking is done"
    root@vagrant:~# ./check_ip_port.sh 
    Ports checking is started
    Port checking is done
    root@vagrant:~# cat log
    nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
    Tue 04 Jan 2022 03:41:47 PM UTC 192.168.0.1:80 is unavailable
    nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
    Tue 04 Jan 2022 03:41:52 PM UTC 192.168.0.1:80 is unavailable
    nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
    Tue 04 Jan 2022 03:41:57 PM UTC 192.168.0.1:80 is unavailable
    nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
    Tue 04 Jan 2022 03:42:02 PM UTC 192.168.0.1:80 is unavailable
    nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
    Tue 04 Jan 2022 03:42:07 PM UTC 192.168.0.1:80 is unavailable
    Connection to 173.194.222.113 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:07 PM UTC
    Connection to 173.194.222.113 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:07 PM UTC
    Connection to 173.194.222.113 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:07 PM UTC
    Connection to 173.194.222.113 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    Connection to 173.194.222.113 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    Connection to 87.250.250.242 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    Connection to 87.250.250.242 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    Connection to 87.250.250.242 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    Connection to 87.250.250.242 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    Connection to 87.250.250.242 80 port [tcp/http] succeeded!
    Tue 04 Jan 2022 03:42:09 PM UTC
    root@vagrant:~# 
 
 ```

4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается
  ### Решение:
  ```
  
      root@vagrant:~# cat check_ip_port_v2.sh 
      #!/usr/bin/env bash
      addresses_ipv4=("173.194.222.113" "87.250.250.242" "192.168.0.1")
      declare -i exit_code
       while ((1==1))
       do	 
          for address in ${addresses_ipv4[@]}
          do
            	    nc -z -v -w 5 $address 80
            	    exit_code=$? 
            	    if [ $exit_code != 0 ]
                            then
            		    echo "$(date) ${address}:80 is unavailable. Exited with code ${exit_code}" >> error
            		    exit
            	    fi	    
          done
       done
      root@vagrant:~# ./check_ip_port_v2.sh 
      Connection to 173.194.222.113 80 port [tcp/http] succeeded!
      Connection to 87.250.250.242 80 port [tcp/http] succeeded!
      nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
      root@vagrant:~# cat error 
      Tue 04 Jan 2022 04:13:03 PM UTC 192.168.0.1:80 is unavailable. Exited with code 1
      root@vagrant:~# 

  ```
  
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.
