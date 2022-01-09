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
    previous_ip_check = ip_check
    ip_check = get_ip(addresses)
    count -= 1
    time.sleep(5)
    print("-----------------------------------------")
    with open("ip_addr.json", 'w') as json_file:
        jd = json.dumps(ip_check, indent=2)
        json_file.write(jd)

    with open('ip_addr.yml', 'w') as yaml_file:
        yaml.dump(ip_check, yaml_file)

