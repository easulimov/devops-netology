#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
# Не используемая переменная
# is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
#       print(prepare_result)
# Печатаем полный путь к файлу
        print(f"{os.getcwd()}/{prepare_result}".replace(" ", ""))
# Отключаем преждевременный выход
#        break