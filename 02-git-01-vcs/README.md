Homework 02


Файл ../terraform/.gitignore

Все исключения, которые описаны в файле ../terraform/.gitignore - относятся только к содержимому директории ../terraform/

1. В коммит не будут добавлены локальные директории ".terraform" и их содержимое(
    Например:
     ./terraform
     somedir/.terraform/
     somedir/.terraform/subdir
)
2. Не будут добавлены все файлы, имя которых завершается на ".tfstate", либо содержит ".tfstate." 
3. Не будет добавлен файл "crash.log"
4. Будут исключены все файлы, имя которых заканчивается на ".tfvars"
5. Будут проигнорированы файлы "override.tf", "override.tf.json" и заканчивающиеся на "_override.tf" и "_override.tf.json"
6. Не будет добавлен файл "terraform.rc" и файлы заканчивающиеся на ".terraformrc"
