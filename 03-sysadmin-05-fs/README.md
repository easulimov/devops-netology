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
    * Выполнено. Немного изменил `Vagrantfile`:
    ```
       Vagrant.configure("2") do |config|
         config.vm.box = "bento/ubuntu-20.04"
         config.vm.provider :virtualbox do |vb|
           vb.gui = true
           vb.name = "ub01"
           vb.memory = 2048
           lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
           lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
           vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
           vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
           vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
           vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
         end
       end
    ```

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
   ```
      vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b,c}1
      mdadm: chunk size defaults to 512K
      mdadm: Defaulting to version 1.2 metadata
      mdadm: array /dev/md1 started.
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
      │ └─md1                9:1    0 1020M  0 raid0 
      └─sdb2                 8:18   0    2G  0 part  
        └─md0                9:0    0    2G  0 raid1 
      sdc                    8:32   0  2.5G  0 disk  
      ├─sdc1                 8:33   0  512M  0 part  
      │ └─md1                9:1    0 1020M  0 raid0 
      └─sdc2                 8:34   0    2G  0 part  
        └─md0                9:0    0    2G  0 raid1 
      vagrant@vagrant:~$ 

   ```
8. Создайте 2 независимых PV на получившихся md-устройствах.
   ### Решение
   ```
      vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
        Physical volume "/dev/md0" successfully created.
        Physical volume "/dev/md1" successfully created.
      vagrant@vagrant:~$ sudo pvs
        PV         VG        Fmt  Attr PSize    PFree   
        /dev/md0             lvm2 ---    <2.00g   <2.00g
        /dev/md1             lvm2 ---  1020.00m 1020.00m
        /dev/sda5  vgvagrant lvm2 a--   <63.50g       0 
      vagrant@vagrant:~$ 
   ```
   
9. Создайте общую volume-group на этих двух PV.
   ### Решение
   ```
      vagrant@vagrant:~$ sudo vgcreate vg1_misc /dev/md0 /dev/md1
      Volume group "vg1_misc" successfully created
      vagrant@vagrant:~$ sudo vgs
      VG        #PV #LV #SN Attr   VSize   VFree 
      vg1_misc    2   0   0 wz--n-  <2.99g <2.99g
      vgvagrant   1   2   0 wz--n- <63.50g     0 
      vagrant@vagrant:~$ sudo pvs
      PV         VG        Fmt  Attr PSize    PFree   
      /dev/md0   vg1_misc  lvm2 a--    <2.00g   <2.00g
      /dev/md1   vg1_misc  lvm2 a--  1016.00m 1016.00m
      /dev/sda5  vgvagrant lvm2 a--   <63.50g       0 
      vagrant@vagrant:~$ 
   ```
   
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    ### Решение
    ```
        vagrant@vagrant:~$ sudo lvcreate -L 100M -n lv_on_raid0 vg1_misc /dev/md1
        Logical volume "lv_on_raid0" created.
        vagrant@vagrant:~$ sudo  lvs -a -o +devices
         LV          VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices         
         lv_on_raid0 vg1_misc  -wi-a----- 100.00m                                                     /dev/md1(0)     
         root        vgvagrant -wi-ao---- <62.54g                                                     /dev/sda5(0)    
         swap_1      vgvagrant -wi-ao---- 980.00m                                                     /dev/sda5(16010)
        vagrant@vagrant:~$
        
    ```
   
11. Создайте `mkfs.ext4` ФС на получившемся LV.
    ### Решение
    ```
       vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg1_misc/lv_on_raid0 
       mke2fs 1.45.5 (07-Jan-2020)
       Creating filesystem with 25600 4k blocks and 25600 inodes
       
       Allocating group tables: done                            
       Writing inode tables: done                            
       Creating journal (1024 blocks): done
       Writing superblocks and filesystem accounting information: done
       
       vagrant@vagrant:~$   
       
     ```
   
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
   ### Решение
   ```
      vagrant@vagrant:~$ mkdir -p /tmp/new
      vagrant@vagrant:~$ sudo mount /dev/mapper/vg1_misc-lv_on_raid0 /tmp/new
      vagrant@vagrant:~$ findmnt
      TARGET                                SOURCE                           FSTYPE     OPTIONS
      /                                     /dev/mapper/vgvagrant-root       ext4       rw,relatime,errors=remount-ro
      ├─/sys                                sysfs                            sysfs      rw,nosuid,nodev,noexec,relatime
      ...
      └─/tmp/new                            /dev/mapper/vg1_misc-lv_on_raid0 ext4       rw,relatime,stripe=256

   ```
   
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
   ### Решение
   ```
       vagrant@vagrant:~$ cd /tmp/new/
       vagrant@vagrant:/tmp/new$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
       --2021-12-12 08:18:18--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
       Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
       Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
       HTTP request sent, awaiting response... 200 OK
       Length: 22718197 (22M) [application/octet-stream]
       Saving to: ‘/tmp/new/test.gz’
       
       /tmp/new/test.gz                               100%[=================================================================================================>]  21.67M  5.94MB/s    in 3.6s    
       
       2021-12-12 08:18:21 (6.10 MB/s) - ‘/tmp/new/test.gz’ saved [22718197/22718197]

       vagrant@vagrant:/tmp/new$ ll
       total 22212
       drwxr-xr-x  3 root root     4096 Dec 12 08:18 ./
       drwxrwxrwt 11 root root     4096 Dec 12 08:07 ../
       drwx------  2 root root    16384 Dec 12 08:04 lost+found/
       -rw-r--r--  1 root root 22718197 Dec 12 04:08 test.gz
       vagrant@vagrant:/tmp/new$ 
   ```
   
14. Прикрепите вывод `lsblk`.
   ### Решение
   ```
      vagrant@vagrant:/tmp/new$ lsblk
      NAME                       MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      sda                          8:0    0   64G  0 disk  
      ├─sda1                       8:1    0  512M  0 part  /boot/efi
      ├─sda2                       8:2    0    1K  0 part  
      └─sda5                       8:5    0 63.5G  0 part  
        ├─vgvagrant-root         253:0    0 62.6G  0 lvm   /
        └─vgvagrant-swap_1       253:1    0  980M  0 lvm   [SWAP]
      sdb                          8:16   0  2.5G  0 disk  
      ├─sdb1                       8:17   0  512M  0 part  
      │ └─md1                      9:1    0 1020M  0 raid0 
      │   └─vg1_misc-lv_on_raid0 253:2    0  100M  0 lvm   /tmp/new
      └─sdb2                       8:18   0    2G  0 part  
        └─md0                      9:0    0    2G  0 raid1 
      sdc                          8:32   0  2.5G  0 disk  
      ├─sdc1                       8:33   0  512M  0 part  
      │ └─md1                      9:1    0 1020M  0 raid0 
      │   └─vg1_misc-lv_on_raid0 253:2    0  100M  0 lvm   /tmp/new
      └─sdc2                       8:34   0    2G  0 part  
        └─md0                      9:0    0    2G  0 raid1 
      vagrant@vagrant:/tmp/new$ 
   ```
   
15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
   ### Решение
   * Примечание: `$?` - это код возврата из процесса последнего запуска. 0 означает, что ошибки не произошло.
   ```
       vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/test.gz 
       vagrant@vagrant:/tmp/new$ echo $?
       0
       vagrant@vagrant:/tmp/new$ 
   ```
   
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
   ### Решение
   ```
      vagrant@vagrant:/tmp/new$ lsblk
      NAME                       MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      sda                          8:0    0   64G  0 disk  
      ├─sda1                       8:1    0  512M  0 part  /boot/efi
      ├─sda2                       8:2    0    1K  0 part  
      └─sda5                       8:5    0 63.5G  0 part  
        ├─vgvagrant-root         253:0    0 62.6G  0 lvm   /
        └─vgvagrant-swap_1       253:1    0  980M  0 lvm   [SWAP]
      sdb                          8:16   0  2.5G  0 disk  
      ├─sdb1                       8:17   0  512M  0 part  
      │ └─md1                      9:1    0 1020M  0 raid0 
      │   └─vg1_misc-lv_on_raid0 253:2    0  100M  0 lvm   /tmp/new
      └─sdb2                       8:18   0    2G  0 part  
        └─md0                      9:0    0    2G  0 raid1 
      sdc                          8:32   0  2.5G  0 disk  
      ├─sdc1                       8:33   0  512M  0 part  
      │ └─md1                      9:1    0 1020M  0 raid0 
      │   └─vg1_misc-lv_on_raid0 253:2    0  100M  0 lvm   /tmp/new
      └─sdc2                       8:34   0    2G  0 part  
        └─md0                      9:0    0    2G  0 raid1 
      vagrant@vagrant:/tmp/new$ sudo pvs
        PV         VG        Fmt  Attr PSize    PFree  
        /dev/md0   vg1_misc  lvm2 a--    <2.00g  <2.00g
        /dev/md1   vg1_misc  lvm2 a--  1016.00m 916.00m
        /dev/sda5  vgvagrant lvm2 a--   <63.50g      0 
      vagrant@vagrant:/tmp/new$ sudo pvmove /dev/md1 /dev/md0
        /dev/md1: Moved: 20.00%
        /dev/md1: Moved: 100.00%
      vagrant@vagrant:/tmp/new$ lsblk
      NAME                       MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
      sda                          8:0    0   64G  0 disk  
      ├─sda1                       8:1    0  512M  0 part  /boot/efi
      ├─sda2                       8:2    0    1K  0 part  
      └─sda5                       8:5    0 63.5G  0 part  
        ├─vgvagrant-root         253:0    0 62.6G  0 lvm   /
        └─vgvagrant-swap_1       253:1    0  980M  0 lvm   [SWAP]
      sdb                          8:16   0  2.5G  0 disk  
      ├─sdb1                       8:17   0  512M  0 part  
      │ └─md1                      9:1    0 1020M  0 raid0 
      └─sdb2                       8:18   0    2G  0 part  
        └─md0                      9:0    0    2G  0 raid1 
          └─vg1_misc-lv_on_raid0 253:2    0  100M  0 lvm   /tmp/new
      sdc                          8:32   0  2.5G  0 disk  
      ├─sdc1                       8:33   0  512M  0 part  
      │ └─md1                      9:1    0 1020M  0 raid0 
      └─sdc2                       8:34   0    2G  0 part  
        └─md0                      9:0    0    2G  0 raid1 
          └─vg1_misc-lv_on_raid0 253:2    0  100M  0 lvm   /tmp/new
      vagrant@vagrant:/tmp/new$ 
   ```
   
17. Сделайте `--fail` на устройство в вашем RAID1 md.
   ### Решение
   ```
   
       vagrant@vagrant:/tmp/new$ sudo mdadm --detail /dev/md0
       /dev/md0:
                  Version : 1.2
            Creation Time : Thu Dec  9 17:13:06 2021
               Raid Level : raid1
               Array Size : 2094080 (2045.00 MiB 2144.34 MB)
            Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
             Raid Devices : 2
            Total Devices : 2
              Persistence : Superblock is persistent
       
              Update Time : Sun Dec 12 08:48:57 2021
                    State : clean 
           Active Devices : 2
          Working Devices : 2
           Failed Devices : 0
            Spare Devices : 0
       
       Consistency Policy : resync
       
                     Name : vagrant:0  (local to host vagrant)
                     UUID : 09809344:734dd708:97ce4d9e:0dd4d442
                   Events : 20
       
           Number   Major   Minor   RaidDevice State
              0       8       18        0      active sync   /dev/sdb2
              1       8       34        1      active sync   /dev/sdc2
       vagrant@vagrant:/tmp/new$ sudo mdadm /dev/md0 --fail /dev/sdb2
       mdadm: set /dev/sdb2 faulty in /dev/md0
       vagrant@vagrant:/tmp/new$ sudo mdadm --detail /dev/md0
       /dev/md0:
                  Version : 1.2
            Creation Time : Thu Dec  9 17:13:06 2021
               Raid Level : raid1
               Array Size : 2094080 (2045.00 MiB 2144.34 MB)
            Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
             Raid Devices : 2
            Total Devices : 2
              Persistence : Superblock is persistent
       
              Update Time : Sun Dec 12 08:59:06 2021
                    State : clean, degraded 
           Active Devices : 1
          Working Devices : 1
           Failed Devices : 1
            Spare Devices : 0
       
       Consistency Policy : resync
       
                     Name : vagrant:0  (local to host vagrant)
                     UUID : 09809344:734dd708:97ce4d9e:0dd4d442
                   Events : 22
       
           Number   Major   Minor   RaidDevice State
              -       0        0        0      removed
              1       8       34        1      active sync   /dev/sdc2
       
              0       8       18        -      faulty   /dev/sdb2
       vagrant@vagrant:/tmp/new$ 
   ```
   
18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
   ### Решение
   * `sudo dmesg -HT`
   ```
      [Sun Dec 12 08:08:36 2021] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
      [Sun Dec 12 08:59:03 2021] md/raid1:md0: Disk failure on sdb2, disabling device.
                           md/raid1:md0: Operation continuing on 1 devices.
   ```
   
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
   ### Решение
   ```
        vagrant@vagrant:/tmp/new$ sudo mdadm --detail /dev/md0
        /dev/md0:
                   Version : 1.2
             Creation Time : Thu Dec  9 17:13:06 2021
                Raid Level : raid1
                Array Size : 2094080 (2045.00 MiB 2144.34 MB)
             Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
              Raid Devices : 2
             Total Devices : 2
               Persistence : Superblock is persistent
        
               Update Time : Sun Dec 12 08:59:06 2021
                     State : clean, degraded 
            Active Devices : 1
           Working Devices : 1
            Failed Devices : 1
             Spare Devices : 0
        
        Consistency Policy : resync
        
                      Name : vagrant:0  (local to host vagrant)
                      UUID : 09809344:734dd708:97ce4d9e:0dd4d442
                    Events : 22
        
            Number   Major   Minor   RaidDevice State
               -       0        0        0      removed
               1       8       34        1      active sync   /dev/sdc2
        
               0       8       18        -      faulty   /dev/sdb2
        vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/test.gz 
        vagrant@vagrant:/tmp/new$ echo $?
        0
        vagrant@vagrant:/tmp/new$ 
   ```
20. Погасите тестовый хост, `vagrant destroy`.
   ### Решение
   * Выполнено
   ```
      logout
      Connection to 127.0.0.1 closed.
      MacBook-Pro-admin:ub01 admin$ vagrant destroy
          default: Are you sure you want to destroy the 'default' VM? [y/N] y
      ==> default: Forcing shutdown of VM...
      ==> default: Destroying VM and associated drives...
      MacBook-Pro-admin:ub01 admin$ 
   ```
