1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
   ### Решение
   * Выполнено.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   ### Решение
   * Файлы, являющиеся жесткой ссылкой на один объект не могут иметь разные права доступа и владельца, так как они ссылаются на один и тот же индексный дескриптор:
   ```
       vagrant@vagrant:~$ echo "Hello world!" > file1
       vagrant@vagrant:~$ ln file1 file2
       vagrant@vagrant:~$ stat file1
         File: file1
         Size: 13        	Blocks: 8          IO Block: 4096   regular file
       Device: fd00h/64768d	Inode: 131121      Links: 2
       Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
       Access: 2021-12-09 14:56:52.713837684 +0000
       Modify: 2021-12-09 14:56:52.713837684 +0000
       Change: 2021-12-09 14:57:02.138547556 +0000
        Birth: -
       vagrant@vagrant:~$ stat file2
         File: file2
         Size: 13        	Blocks: 8          IO Block: 4096   regular file
       Device: fd00h/64768d	Inode: 131121      Links: 2
       Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
       Access: 2021-12-09 14:56:52.713837684 +0000
       Modify: 2021-12-09 14:56:52.713837684 +0000
       Change: 2021-12-09 14:57:02.138547556 +0000
        Birth: -
       vagrant@vagrant:~$ ls -lahF file*
       -rw-rw-r-- 2 vagrant vagrant 13 Dec  9 14:56 file1
       -rw-rw-r-- 2 vagrant vagrant 13 Dec  9 14:56 file2
       vagrant@vagrant:~$ chmod o-r file2
       vagrant@vagrant:~$ ls -lahF file*
       -rw-rw---- 2 vagrant vagrant 13 Dec  9 14:56 file1
       -rw-rw---- 2 vagrant vagrant 13 Dec  9 14:56 file2
       vagrant@vagrant:~$ 
   ```
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
    ### Решение:
    * Выполнено.

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
   ### Решение
   ```
      vagrant@vagrant:~$ lsblk
      NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      sda                    8:0    0   64G  0 disk 
      ├─sda1                 8:1    0  512M  0 part /boot/efi
      ├─sda2                 8:2    0    1K  0 part 
      └─sda5                 8:5    0 63.5G  0 part 
        ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
        └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
      sdb                    8:16   0  2.5G  0 disk 
      sdc                    8:32   0  2.5G  0 disk 
      vagrant@vagrant:~$ 
      vagrant@vagrant:~$ sudo fdisk /dev/sdb
      ...
      Command (m for help): p
      
      Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
      Disk model: VBOX HARDDISK   
      Units: sectors of 1 * 512 = 512 bytes
      Sector size (logical/physical): 512 bytes / 512 bytes
      I/O size (minimum/optimal): 512 bytes / 512 bytes
      Disklabel type: dos
      Disk identifier: 0x33b67015
      
      Device     Boot   Start     End Sectors  Size Id Type
      /dev/sdb1          2048 1050623 1048576  512M 83 Linux
      /dev/sdb2       1050624 5242879 4192256    2G 83 Linux
      
      Command (m for help): w
      The partition table has been altered.
      Calling ioctl() to re-read partition table.
      Syncing disks.
      
      vagrant@vagrant:~$ 
      vagrant@vagrant:~$ lsblk
      NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      sda                    8:0    0   64G  0 disk 
      ├─sda1                 8:1    0  512M  0 part /boot/efi
      ├─sda2                 8:2    0    1K  0 part 
      └─sda5                 8:5    0 63.5G  0 part 
        ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
        └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
      sdb                    8:16   0  2.5G  0 disk 
      ├─sdb1                 8:17   0  512M  0 part 
      └─sdb2                 8:18   0    2G  0 part 
      sdc                    8:32   0  2.5G  0 disk 
      vagrant@vagrant:~$ 
   
   ```
   
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
   ### Решение
   ```
   
      vagrant@vagrant:~$ sudo bash -c "sfdisk -d /dev/sdb | sfdisk /dev/sdc"
      Checking that no-one is using this disk right now ... OK
      
      Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
      Disk model: VBOX HARDDISK   
      Units: sectors of 1 * 512 = 512 bytes
      Sector size (logical/physical): 512 bytes / 512 bytes
      I/O size (minimum/optimal): 512 bytes / 512 bytes
      
      >>> Script header accepted.
      >>> Script header accepted.
      >>> Script header accepted.
      >>> Script header accepted.
      >>> Created a new DOS disklabel with disk identifier 0x238715f1.
      /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 512 MiB.
      /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 2 GiB.
      /dev/sdc3: Done.
      
      New situation:
      Disklabel type: dos
      Disk identifier: 0x238715f1
      
      Device     Boot   Start     End Sectors  Size Id Type
      /dev/sdc1          2048 1050623 1048576  512M 83 Linux
      /dev/sdc2       1050624 5242879 4192256    2G 83 Linux

      The partition table has been altered.
      Calling ioctl() to re-read partition table.
      Syncing disks.
      vagrant@vagrant:~$ lsblk
      NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      sda                    8:0    0   64G  0 disk 
      ├─sda1                 8:1    0  512M  0 part /boot/efi
      ├─sda2                 8:2    0    1K  0 part 
      └─sda5                 8:5    0 63.5G  0 part 
        ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
        └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
      sdb                    8:16   0  2.5G  0 disk 
      ├─sdb1                 8:17   0  512M  0 part 
      └─sdb2                 8:18   0    2G  0 part 
      sdc                    8:32   0  2.5G  0 disk 
      ├─sdc1                 8:33   0  512M  0 part 
      └─sdc2                 8:34   0    2G  0 part 
      vagrant@vagrant:~$ sudo sfdisk -d /dev/sdc | less
      vagrant@vagrant:~$ 
   ```
   
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
   ### Решение
   ```
       vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b,c}2
       mdadm: Note: this array has metadata at the start and
           may not be suitable as a boot device.  If you plan to
           store '/boot' on this device please ensure that
           your boot-loader understands md/v1.x metadata, or use
           --metadata=0.90
       mdadm: size set to 2094080K
       Continue creating array? y
       mdadm: Defaulting to version 1.2 metadata
       mdadm: array /dev/md0 started.
       vagrant@vagrant:~$ lsblk
       NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
       sda                    8:0    0   64G  0 disk  
       ├─sda1                 8:1    0  512M  0 part  /boot/efi
       ├─sda2                 8:2    0    1K  0 part  
       └─sda5                 8:5    0 63.5G  0 part  
         ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
         └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
       sdb                    8:16   0  2.5G  0 disk  
       ├─sdb1                 8:17   0  512M  0 part  
       └─sdb2                 8:18   0    2G  0 part  
         └─md0                9:0    0    2G  0 raid1 
       sdc                    8:32   0  2.5G  0 disk  
       ├─sdc1                 8:33   0  512M  0 part  
       └─sdc2                 8:34   0    2G  0 part  
         └─md0                9:0    0    2G  0 raid1 
       vagrant@vagrant:~$ 
   
   ```
   
7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
   ### Решение
   
8. Создайте 2 независимых PV на получившихся md-устройствах.
   ### Решение
   
9. Создайте общую volume-group на этих двух PV.
   ### Решение
   
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
   ### Решение
   
11. Создайте `mkfs.ext4` ФС на получившемся LV.
   ### Решение
   
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
   ### Решение
   
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
   ### Решение
   
14. Прикрепите вывод `lsblk`.
   ### Решение
   
15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
   ### Решение
   
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
   ### Решение
   
17. Сделайте `--fail` на устройство в вашем RAID1 md.
   ### Решение
   
18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
   ### Решение
   
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
   ### Решение
   
20. Погасите тестовый хост, `vagrant destroy`.
   ### Решение
   
