# Dm-crypt

## 参考文档

* [Dm-crypt](https://wiki.gentoo.org/wiki/Dm-crypt)
* [Kernel FSL OTP Driver](0003_Kernel_FSL_OTP_Driver.md)
* [dm-crypt加密磁盘](http://www.zphj1987.com/2015/05/25/dm-crypt%E5%8A%A0%E5%AF%86%E7%A3%81%E7%9B%98/)
* [利用luks加密linux磁盘](https://blog.csdn.net/kid_2412/article/details/61615407)
* [磁盘加密工具cryptsetup](https://blog.csdn.net/super2feng/article/details/53747647)

## Kernel Configuration

* Enabling device mapper and crypt target
  ```
  [*] Enable loadable module support
  Device Drivers --->
      [*] Multiple devices driver support (RAID and LVM) --->
          <*> Device mapper support
              <*> Crypt target support
  ```
* Enabling cryptographic API functions
  ```
  [*] Cryptographic API --->
      <*> XTS support
      <*> SHA224 and SHA256 digest algorithm
      <*> AES cipher algorithms
      <*> AES cipher algorithms (x86_64)
      <*> User-space interface for hash algorithms
      <*> User-space interface for symmetric key cipher algorithms
  ```
* Enabling tcrypt (TrueCrypt/tcplay/VeraCrypt compatibility mode) support
  ```
  Device Drivers --->
      [*] Block Devices ---> 
          <*> Loopback device support 
  File systems ---> 
       <*> FUSE (Filesystem in Userspace) support 
  [*] Cryptographic API ---> 
       <*> RIPEMD-160 digest algorithm 
       <*> SHA384 and SHA512 digest algorithms 
       <*> Whirlpool digest algorithms 
       <*> LRW support 
       <*> Serpent cipher algorithm 
       <*> Twofish cipher algorithm
  ```

## 查看内核加密支持信息

* `cat /proc/crypto`
  ```
  [...省略]
  name         : aes
  driver       : aes-generic
  module       : kernel
  priority     : 100
  refcnt       : 1
  selftest     : passed
  internal     : no
  type         : cipher
  blocksize    : 16
  min keysize  : 16
  max keysize  : 32
  [...省略]
  ```
* `ls -l /dev/mapper/control`: `crw-rw---- 1 root root 10, 236 Jan  1 00:00 /dev/mapper/control`

## Buildroot md-crypt Test

* `make menuconfig`
  ```
   /home/zengjf/zengjf/Buildroot/buildroot/.config - Buildroot 2017.02.3-gca4ea10-
  d> Search (cryptsetup) qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    lqqqqqqqqqqqqqqqqqqqqqqqqqqqq Search Results qqqqqqqqqqqqqqqqqqqqqqqqqqqqqk
    x Symbol: BR2_PACKAGE_CRYPTSETUP [=y]                                     x
    x Type  : boolean                                                         x
    x Prompt: cryptsetup                                                      x
    x   Location:                                                             x
    x     -> Target packages                                                  x
    x (1)   -> Hardware handling                                              x
    x   Defined at package/cryptsetup/Config.in:1                             x
    x   Depends on: BR2_TOOLCHAIN_HAS_THREADS [=y] && BR2_USE_MMU [=y] && !BR x
    x   Selects: BR2_PACKAGE_POPT [=y] && BR2_PACKAGE_LVM2 [=y] && BR2_PACKAG x
    x                                                                         x
    x                                                                         x
    x                                                                         x
    x                                                                         x
    x                                                                         x
    x                                                                         x
    x                                                                         x
    tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq(100%)qqu
    x                                < Exit >                                 x
    mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj
  
  ```
* `dmsetup targets`
  ```
  crypt            v1.14.1
  striped          v1.5.1
  linear           v1.2.1
  error            v1.3.0
  ```
* 创建并加载加密盘：`cryptsetup -y create sdb_cry /dev/sda1`
  ```
  Enter passphrase:
  Verify passphrase:
  ```
* 列表加密盘：`dmsetup ls`
  ```
  sdb_cry (254:0)
  ```
* 查看mapper目录：`ls /dev/mapper/`
  ```
  control  sdb_cry
  ```
* 格式化磁盘：`mkfs.ext4 /dev/mapper/sdb_cry`
  ```
  mke2fs 1.43.3 (04-Sep-2016)
  Creating filesystem with 1927792 4k blocks and 482384 inodes
  Filesystem UUID: 6d710d5f-2ec9-4cae-aa30-cf389a2bb813
  Superblock backups stored on blocks:
          32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
  
  Allocating group tables: done
  Writing inode tables: done
  Creating journal (16384 blocks): done
  Writing superblocks and filesystem accounting information: done
  ```
* 挂载磁盘：`mount /dev/mapper/sdb_cry /mnt`
* 卸载磁盘：`umount /mnt`
* 卸载对应的加密磁盘：`cryptsetup remove sdb_cry`
* 重新对加密磁盘进行加载：`cryptsetup create sdb_cry /dev/sda1 `

## LUKS（Linux Unified Key Setup）

* `cryptsetup luksFormat /dev/sda1`
* `cryptsetup luksOpen /dev/sda2 xxx`： xxx --> 映射名
* `ls /dev/mapper/`
* `mkfs.ext4 /dev/mapper/xxx`：         xxx --> 映射名
* `mkdir /mnt/xxx`：                    xxx --> 映射名
* `mount /dev/mapper/xxx /mnt/xxx`：    xxx --> 映射名
* `umount /mnt/xxx`：                   xxx --> 映射名
* `cryptsetup close xxx`：              xxx --> 映射名
* LUKS 加密盘使用 keyfile 作为认证因素
  * `dd if=/dev/urandom of=keyfile bs=1k count=64`
  * `cryptsetup luksDump /dev/sdb1`
  * `cryptsetup luksAddKey /dev/sdb1 keyfile`
  * `cryptsetup --key-file keyfile luksOpen /dev/sdb1 xxx`：xxx --> 映射名
  * `cryptsetup luksKillSlot /dev/sdb1 Slot的编号`
* 使用fstab、crypttab可以实现自动加载加密的文件系统；
