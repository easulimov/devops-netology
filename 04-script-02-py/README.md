## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | ???  |
| Как получить для переменной `c` значение 12?  | ???  |
| Как получить для переменной `c` значение 3?  | ???  |

### Решение

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | `TypeError: unsupported operand type(s) for +: 'int' and 'str'`  |
| Как получить для переменной `c` значение 12?  | `c = str(a) + b`  |
| Как получить для переменной `c` значение 3?  |  `c = a + int(b)` |


## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```
### Решение

### Ваш скрипт:
   ```python
       #!/usr/bin/env python3
       
       import os
       
       bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
       result_os = os.popen(' && '.join(bash_command)).read()
       
       # Получаем полный путь рабочей директории (директория локального репозитория)
       wd_path = os.path.expanduser("~/netology/sysadm-homeworks")
       
       # Не используемая переменная
       # is_change = False
       
       for result in result_os.split('\n'):
           if result.find('изменено') != -1:
               prepare_result = result.replace('\tизменено:   ', '')
	       
       #       print(prepare_result)
       
       # Печатаем полный путь к файлу
               print(f"{wd_path}/{prepare_result}".replace(" ", ""))
       # Отключаем преждевременный выход
       #        break
   
   ```
### Вывод скрипта при запуске при тестировании:
   ```
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ ./script2.py 
       /home/gendalf/netology/sysadm-homeworks/1.txt
       /home/gendalf/netology/sysadm-homeworks/2.txt
       /home/gendalf/netology/sysadm-homeworks/3.txt
       /home/gendalf/netology/sysadm-homeworks/internal_dir/22
       /home/gendalf/netology/sysadm-homeworks/internal_dir/23
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ 

   ```
## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Решение

### Ваш скрипт:
   ```python
        #!/usr/bin/env python3
        
        import os
        from sys import argv
        from sys import exit
        
        try:
            repo_path = argv[1]
        except IndexError:
            print("Не указан путь к репозиторию")
            exit(1)



        def is_repo(dir_path):
            bash_command = [f"cd {dir_path}", "git status 2>&1"]
            result_os = os.popen(' && '.join(bash_command)).read()
            status = True
            for result in result_os.split('\n'):
               if result.find('fatal') != -1:
                    status = False
                    return status
            return status
        
        
        def find_modified_files(dir_path):
            bash_command = [f"cd {dir_path}", "git status"]
            result_os = os.popen(' && '.join(bash_command)).read()
            status = 0
            for result in result_os.split('\n'):
                if result.find('изменено') != -1:
                    status += 1
                    prepare_result = result.replace('\tизменено:   ', '')
                    final_result = (f"{dir_path}/{prepare_result}".replace(" ", "")).replace("//", "/")
                    print(final_result)
            if (status == 0):
                print(f"В репозитории по указанному пути {dir_path} - нет измененных файлов")
        
        
        
        if repo_path.find("~/") != -1:
            repo_path = os.path.expanduser(repo_path)

        if os.path.exists(repo_path):
            if is_repo(repo_path):
                find_modified_files(repo_path)
            else:
                print(f" Указанный путь {repo_path} - не является репозиторием")
        else:
            print(f"Указанный путь {repo_path} - не существует")

   ```
### Вывод скрипта при запуске при тестировании:
   ```
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ ./script3.py ~/netology/sysadm-homeworks
       /home/gendalf/netology/sysadm-homeworks/1.txt
       /home/gendalf/netology/sysadm-homeworks/internal_dir/22
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ ./script3.py ~/netology/sysadm-homework123213123
       Указанный путь /home/gendalf/netology/sysadm-homework123213123 - не существует
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ ./script3.py
       Не указан путь к репозиторию
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$

   ```
## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Решение
### Ваш скрипт:
   ```python
       #!/usr/bin/env python3
       
       import socket
       import time
       
       addresses = ["drive.google.com", "mail.google.com", "google.com"]
       
       def get_ip(addresses):
           ip_dict = {}
           for address in addresses:
               ip_addr = socket.gethostbyname(address)
               ip_dict[address] = ip_addr
           return ip_dict
       
       
       def print_changed_ip(previous_ip_check, ip_check):
           if previous_ip_check == ip_check:
               for key, value in ip_check.items():
                   print(f"URL <{key}> - IP {value} ")
           else:
               for key, value in ip_check.items():
                   if ip_check[key] != previous_ip_check[key]:
                       print(f"[ERROR] <{key}> IP mismatch: <{previous_ip_check[key]}> <{value}>. ")
                   else:
                       print(f"URL <{key}> - IP {value} ")
       
       
       count = 5
       ip_check = get_ip(addresses)
       previous_ip_check = ip_check
       while count != 0:
       # Для демонстрационных целей, количество проходов ограничено 5. Чтобы сделать выполнение адресов непрерывным
       # надо изменить условие while count != 0: на while True:
           print_changed_ip(previous_ip_check, ip_check)
           previous_ip_check = ip_check
           ip_check = get_ip(addresses)
           count -= 1
           time.sleep(5)
           print("-----------------------------------------")

   ```

### Вывод скрипта при запуске при тестировании:
   ```
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ ./script4.py 
       URL <drive.google.com> - IP 108.177.14.194 
       URL <mail.google.com> - IP 173.194.73.17 
       URL <google.com> - IP 64.233.165.101 
       -----------------------------------------
       URL <drive.google.com> - IP 108.177.14.194 
       [ERROR] <mail.google.com> IP mismatch: <173.194.73.17> <173.194.73.19>. 
       [ERROR] <google.com> IP mismatch: <64.233.165.101> <64.233.165.102>. 
       -----------------------------------------
       URL <drive.google.com> - IP 108.177.14.194 
       [ERROR] <mail.google.com> IP mismatch: <173.194.73.19> <173.194.73.18>. 
       [ERROR] <google.com> IP mismatch: <64.233.165.102> <64.233.165.101>. 
       -----------------------------------------
       URL <drive.google.com> - IP 108.177.14.194 
       [ERROR] <mail.google.com> IP mismatch: <173.194.73.18> <173.194.73.17>. 
       [ERROR] <google.com> IP mismatch: <64.233.165.101> <64.233.165.138>. 
       -----------------------------------------
       URL <drive.google.com> - IP 108.177.14.194 
       URL <mail.google.com> - IP 173.194.73.17 
       [ERROR] <google.com> IP mismatch: <64.233.165.138> <64.233.165.113>. 
       -----------------------------------------
       gendalf@pc01:~/PycharmProjects/devops-netology/04-script-02-py/test$ 
   
   ```
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```

