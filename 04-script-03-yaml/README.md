## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
	```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
  
  ### Решение
  ```json
          { "info" : "Sample JSON output from our service\t",
                  "elements" :[
                      { "name" : "first",
                      "type" : "server",
                      "ip" : 7175 
                      },
                      { "name" : "second",
                      "type" : "proxy",
                      "ip" : "71.78.22.43"
                      }
                  ]
              }   
               
  ```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.
  ### Решение
  
  ### Ваш скрипт:
  ```python
#!/usr/bin/env python3

import socket
import time
import json
import yaml

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
    with open("ip_addr.json", 'w') as json_file:
        jd = json.dumps(ip_check, sort_keys=False, indent=2)
        json_file.write(jd)

    with open('ip_addr.yml', 'w') as yaml_file:
        yaml.dump(ip_check, yaml_file, sort_keys=False)

    previous_ip_check = ip_check
    ip_check = get_ip(addresses)
    count -= 1
    time.sleep(5)
    print("-----------------------------------------")

  ```

  ### Вывод скрипта при запуске при тестировании:
  ```
gendalf@pc01:~/PycharmProjects/devops-netology/04-script-03-yaml$ ./script.py 
URL <drive.google.com> - IP 108.177.14.194 
URL <mail.google.com> - IP 173.194.73.19 
URL <google.com> - IP 173.194.220.138 
-----------------------------------------
URL <drive.google.com> - IP 108.177.14.194 
[ERROR] <mail.google.com> IP mismatch: <173.194.73.19> <173.194.73.17>. 
[ERROR] <google.com> IP mismatch: <173.194.220.138> <173.194.220.113>. 
-----------------------------------------
URL <drive.google.com> - IP 108.177.14.194 
[ERROR] <mail.google.com> IP mismatch: <173.194.73.17> <173.194.73.18>. 
URL <google.com> - IP 173.194.220.113 
-----------------------------------------
URL <drive.google.com> - IP 108.177.14.194 
[ERROR] <mail.google.com> IP mismatch: <173.194.73.18> <173.194.73.17>. 
URL <google.com> - IP 173.194.220.113 
-----------------------------------------
URL <drive.google.com> - IP 108.177.14.194 
[ERROR] <mail.google.com> IP mismatch: <173.194.73.17> <173.194.73.19>. 
[ERROR] <google.com> IP mismatch: <173.194.220.113> <173.194.220.100>. 
-----------------------------------------
gendalf@pc01:~/PycharmProjects/devops-netology/04-script-03-yaml$ 


  ```
### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "drive.google.com": "108.177.14.194",
  "mail.google.com": "173.194.73.19",
  "google.com": "173.194.220.100"
}

```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 108.177.14.194
mail.google.com: 173.194.73.19
google.com: 173.194.220.100

```  
  
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???
