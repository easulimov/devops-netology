### Задание
Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом терраформа https://github.com/hashicorp/terraform
В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены.

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на **aefea**.
    ####Решение:
    * Полный хеш коммита:
        > aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    * Комментарий коммита:
        > Update CHANGELOG.md
    * Команда:
        > git show -q aefea  

#      
2. Какому тегу соответствует коммит **85024d3**?
    ####Решение:
     * Коммиту **85024d3100126de36331c6982bfaac02cdab9e76** соответвует тег: **"tag: v0.12.23"**
     * Команда:
        > git show -q 85024d3 
     * Также, можно использовать команды:
       
       > git tag --points-at 85024d
       * Выведет только тег "v0.12.23"
       
       > git describe --all --exact-match 85024d
       * Выведет тег в формате "tags/v0.12.23"

#      
3. Сколько родителей у коммита **b8d720**? Напишите их хеши.
    ####Решение:
    * У коммита **b8d720** два родителя : **56cd7859e** и **9ea88f22f**
    * Команда 
        > git show b8d720 
        - покажет нам, что коммит является результатом слияния двух коммитов  **Merge: 56cd7859e 9ea88f22f**
    * Узнать хэши каждого родителя по отдельности:
        >git show -q 58dcac4b7^1 
        - Покажет родителя №1 
        > git show -q ffbcf5581^2    
        - Покажет родителя №2
    * Показать хэши родителей на отдельных строках без дополнительной информации:
        >git rev-parse b8d720^@
    * Показать хэши родителей коммита и сообщение: 
        > git log - git log --pretty=format:'%P %s' -n 1 --graph b8d720
     

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
    ####Решение:
     *Вывод*:
     33ff1c03b (tag: v0.12.24) v0.12.24
     b14b74c49 [Website] vmc provider links
     3f235065b Update CHANGELOG.md
     6ae64e247 registry: Fix panic when server is unreachable
     5c619ca1b website: Remove links to the getting started guide's old location
     06275647e Update CHANGELOG.md
     d5f9411f5 command: Fix bug when using terraform login on Windows
     4b6d06cc5 Update CHANGELOG.md
     dd01a3507 Update CHANGELOG.md
     225466bc3 Cleanup after v0.12.23 release
    Команда - git log --oneline v0.12.23..v0.12.24


5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
    Решение: 

6. Найдите все коммиты в которых была изменена функция globalPluginDirs.
    Решение:
    
7. Кто автор функции synchronizedWriters?
    Решение: 

