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

