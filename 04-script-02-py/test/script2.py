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