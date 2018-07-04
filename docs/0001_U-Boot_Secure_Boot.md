# U-Boot Secure Boot 

[csf-sign: tool for sign u-boot use generated key](../linux64/csf-sign)

## 参考文档

* https://www.nxp.com/docs/en/application-note/AN4581.pdf
* https://www.nxp.com/webapp/Download?colCode=IMX_CST_TOOL&appType=license&location=null&Parent_nodeId=&Parent_pageType=

## 操作流程

* `tar xvf cst-3.0.1.tgz`；
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1$ tree -L 3
  .
  ├── ca
  │   ├── openssl.cnf
  │   ├── v3_ca.cnf
  │   └── v3_usr.cnf
  ├── code
  │   ├── back_end
  │   │   ├── hdr
  │   │   └── src
  │   └── hab3
  │       └── hdr
  ├── crts
  ├── docs
  │   ├── CST_UG.pdf
  │   └── HAB4_API.pdf
  ├── keys
  │   ├── add_key.bat
  │   ├── add_key.sh
  │   ├── ahab_pki_tree.bat
  │   ├── ahab_pki_tree.sh
  │   ├── hab3_pki_tree.bat
  │   ├── hab3_pki_tree.sh
  │   ├── hab4_pki_tree.bat
  │   └── hab4_pki_tree.sh
  ├── LICENSE.nxp
  ├── LICENSE.openssl
  ├── linux32
  │   ├── bin
  │   │   ├── cst
  │   │   ├── srktool
  │   │   └── x5092wtls
  │   └── lib
  │       ├── libbackend.a
  │       └── libfrontend.a
  ├── linux64
  │   ├── bin
  │   │   ├── cst
  │   │   ├── srktool
  │   │   └── x5092wtls
  │   └── lib
  │       ├── libbackend.a
  │       └── libfrontend.a
  ├── mingw32
  │   ├── bin
  │   │   ├── cst.exe
  │   │   ├── srktool.exe
  │   │   └── x5092wtls.exe
  │   └── lib
  │       ├── libbackend.a
  │       └── libfrontend.a
  └── Release_Notes.txt
  ```
* `./hab4_pki_tree.sh`
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1/keys$ ./hab4_pki_tree.sh
      +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      This script is a part of the Code signing tools for Freescale's
      High Assurance Boot.  It generates a basic PKI tree.  The PKI
      tree consists of one or more Super Root Keys (SRK), with each
      SRK having two subordinate keys:
          + a Command Sequence File (CSF) key
          + Image key.
      Additional keys can be added to the PKI tree but a separate
      script is available for this.  This this script assumes openssl
      is installed on your system and is included in your search
      path.  Finally, the private keys generated are password
      protectedwith the password provided by the file key_pass.txt.
      The format of the file is the password repeated twice:
          my_password
          my_password
      All private keys in the PKI tree are in PKCS #8 format will be
      protected by the same password.
  
      +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Do you want to use an existing CA key (y/n)?: n
  Enter key length in bits for PKI tree: 2048
  Enter PKI tree duration (years): 10
  How many Super Root Keys should be generated? 4
  Do you want the SRK certificates to have the CA flag set? (y/n)?: y
  A default 'serial' file was created!
  A default file 'key_pass.txt' was created with password = test!
  ...[省略]
  zengjf@zengjf:~/zengjf/cst-3.0.1/keys$ tree
  .
  ├── 12345678.pem
  ├── 12345679.pem
  ├── 1234567A.pem
  ├── 1234567B.pem
  ├── 1234567C.pem
  ├── 1234567D.pem
  ├── 1234567E.pem
  ├── 1234567F.pem
  ├── 12345680.pem
  ├── 12345681.pem
  ├── 12345682.pem
  ├── 12345683.pem
  ├── add_key.bat
  ├── add_key.sh
  ├── ahab_pki_tree.bat
  ├── ahab_pki_tree.sh
  ├── CA1_sha256_2048_65537_v3_ca_key.der
  ├── CA1_sha256_2048_65537_v3_ca_key.pem
  ├── CSF1_1_sha256_2048_65537_v3_usr_key.der
  ├── CSF1_1_sha256_2048_65537_v3_usr_key.pem
  ├── CSF2_1_sha256_2048_65537_v3_usr_key.der
  ├── CSF2_1_sha256_2048_65537_v3_usr_key.pem
  ├── CSF3_1_sha256_2048_65537_v3_usr_key.der
  ├── CSF3_1_sha256_2048_65537_v3_usr_key.pem
  ├── CSF4_1_sha256_2048_65537_v3_usr_key.der
  ├── CSF4_1_sha256_2048_65537_v3_usr_key.pem
  ├── hab3_pki_tree.bat
  ├── hab3_pki_tree.sh
  ├── hab4_pki_tree.bat
  ├── hab4_pki_tree.sh
  ├── IMG1_1_sha256_2048_65537_v3_usr_key.der
  ├── IMG1_1_sha256_2048_65537_v3_usr_key.pem
  ├── IMG2_1_sha256_2048_65537_v3_usr_key.der
  ├── IMG2_1_sha256_2048_65537_v3_usr_key.pem
  ├── IMG3_1_sha256_2048_65537_v3_usr_key.der
  ├── IMG3_1_sha256_2048_65537_v3_usr_key.pem
  ├── IMG4_1_sha256_2048_65537_v3_usr_key.der
  ├── IMG4_1_sha256_2048_65537_v3_usr_key.pem
  ├── index.txt
  ├── index.txt.attr
  ├── index.txt.attr.old
  ├── index.txt.old
  ├── key_pass.txt
  ├── serial
  ├── serial.old
  ├── SRK1_sha256_2048_65537_v3_ca_key.der
  ├── SRK1_sha256_2048_65537_v3_ca_key.pem
  ├── SRK2_sha256_2048_65537_v3_ca_key.der
  ├── SRK2_sha256_2048_65537_v3_ca_key.pem
  ├── SRK3_sha256_2048_65537_v3_ca_key.der
  ├── SRK3_sha256_2048_65537_v3_ca_key.pem
  ├── SRK4_sha256_2048_65537_v3_ca_key.der
  └── SRK4_sha256_2048_65537_v3_ca_key.pem
  ```
* `../linux64/bin/srktool -h 4 -t SRK_1_2_3_4_table.bin -e SRK_1_2_3_4_fuse.bin -d sha256 -c SRK1_sha256_2048_65537_v3_ca_crt.pem,SRK2_sha256_2048_65537_v3_ca_crt.pem,SRK3_sha256_2048_65537_v3_ca_crt.pem,SRK4_sha256_2048_65537_v3_ca_crt.pem`
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1/crts$ tree
  .
  ├── CA1_sha256_2048_65537_v3_ca_crt.der
  ├── CA1_sha256_2048_65537_v3_ca_crt.pem
  ├── CSF1_1_sha256_2048_65537_v3_usr_crt.der
  ├── CSF1_1_sha256_2048_65537_v3_usr_crt.pem
  ├── CSF2_1_sha256_2048_65537_v3_usr_crt.der
  ├── CSF2_1_sha256_2048_65537_v3_usr_crt.pem
  ├── CSF3_1_sha256_2048_65537_v3_usr_crt.der
  ├── CSF3_1_sha256_2048_65537_v3_usr_crt.pem
  ├── CSF4_1_sha256_2048_65537_v3_usr_crt.der
  ├── CSF4_1_sha256_2048_65537_v3_usr_crt.pem
  ├── IMG1_1_sha256_2048_65537_v3_usr_crt.der
  ├── IMG1_1_sha256_2048_65537_v3_usr_crt.pem
  ├── IMG2_1_sha256_2048_65537_v3_usr_crt.der
  ├── IMG2_1_sha256_2048_65537_v3_usr_crt.pem
  ├── IMG3_1_sha256_2048_65537_v3_usr_crt.der
  ├── IMG3_1_sha256_2048_65537_v3_usr_crt.pem
  ├── IMG4_1_sha256_2048_65537_v3_usr_crt.der
  ├── IMG4_1_sha256_2048_65537_v3_usr_crt.pem
  ├── SRK_1_2_3_4_fuse.bin
  ├── SRK_1_2_3_4_table.bin
  ├── SRK1_sha256_2048_65537_v3_ca_crt.der
  ├── SRK1_sha256_2048_65537_v3_ca_crt.pem
  ├── SRK2_sha256_2048_65537_v3_ca_crt.der
  ├── SRK2_sha256_2048_65537_v3_ca_crt.pem
  ├── SRK3_sha256_2048_65537_v3_ca_crt.der
  ├── SRK3_sha256_2048_65537_v3_ca_crt.pem
  ├── SRK4_sha256_2048_65537_v3_ca_crt.der
  └── SRK4_sha256_2048_65537_v3_ca_crt.pem
  ```
* `hexdump -e '/4 "0x"' -e '/4 "%X""\n"' SRK_1_2_3_4_fuse.bin`
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1/crts$ hexdump -e '/4 "0x"' -e '/4 "%X""\n"' SRK_1_2_3_4_fuse.bin
  0x442024E5
  0x73343E75
  0xF83D526E
  0xA8C56A62
  0x58DD8F6F
  0x60400336
  0xA62BC0D8
  0x1E950925
  ```
* Program the fuse values using the fuse command, available in i.MX U-Boot.
  ```
  fuse prog 3 0 0x442024E5
  fuse prog 3 1 0x73343E75
  fuse prog 3 2 0xF83D526E
  fuse prog 3 3 0xA8C56A62
  fuse prog 3 4 0x58DD8F6F
  fuse prog 3 5 0x60400336
  fuse prog 3 6 0xA62BC0D8
  fuse prog 3 7 0x1E950925
  ```
* U-Boot编译输出信息，注意这里的HAB Blocks信息，csf file最后一行需要这里的信息，Make加上V=1参数才能看到信息
  ```
  [...省略]
    ./tools/mkimage -n board/freescale/mx6sabresd/mx6dlsabresd.cfg.cfgtmp -T imximage -e 0x17800000 -d u-boot.bin u-boot.imx
  Image Type:   Freescale IMX Boot Image
  Image Ver:    2 (i.MX53/6/7 compatible)
  Mode:         DCD
  Data Size:    561152 Bytes = 548.00 kB = 0.54 MB
  Load Address: 177ff420
  Entry Point:  17800000
  HAB Blocks:   177ff400 00000000 00084c00
  ```
* csf file
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1/linux64$ cat csf-uboot
  #Illustrative Command Sequence File Description
  [Header]
  Version = 4.2
  Hash Algorithm = sha256
  Engine = CAAM
  Engine Configuration = 0
  Certificate Format = X509
  Signature Format = CMS
  [Install SRK]
  File = "../crts/SRK_1_2_3_4_table.bin"
  # Index of the key location in the SRK table to be installed
  Source index = 0
  [Install CSFK]
  # Key used to authenticate the CSF data
  File = "../crts/CSF1_1_sha256_2048_65537_v3_usr_crt.pem"
  [Authenticate CSF]
  [Install Key]
  # Key slot index used to authenticate the key to be installed
  Verification index = 0
  # Target key slot in HAB key store where key will be installed
  Target Index = 2
  # Key to install
  File= "../crts/IMG1_1_sha256_2048_65537_v3_usr_crt.pem"
  [Authenticate Data]
  # Key slot index used to authenticate the image data
  Verification index = 2
  # Address Offset Length Data File Path
  # Blocks = 0x877fb000 0x000 0x48000 "u-boot.imx"
  Blocks = 0x177fb000 0x000 0x00084c00 "u-boot.imx"
  ```
* CSF Processed
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1/crts$ cp ../../Buildroot/buildroot/output/build/uboot-fsl_uboot_L4.1.15_from_TP/u-boot.imx .
  zengjf@zengjf:~/zengjf/cst-3.0.1/linux64$ ls
  bin  csf-uboot  lib  u-boot.imx
  zengjf@zengjf:~/zengjf/cst-3.0.1/linux64$ ./bin/cst -o csf-uboot.bin -i csf-uboot
  CSF Processed successfully and signed data available in csf-uboot.bin
  zengjf@zengjf:~/zengjf/cst-3.0.1/linux64$ tree -L 3
  .
  ├── bin
  │   ├── cst
  │   ├── srktool
  │   └── x5092wtls
  ├── csf-uboot
  ├── csf-uboot.bin
  ├── lib
  │   ├── libbackend.a
  │   └── libfrontend.a
  └── u-boot.imx
  ```
* Dumping U-boot binary
  ```
  zengjf@zengjf:~/zengjf/cst-3.0.1/linux64$ od -X -N 0x20 u-boot.imx
  0000000 402000d1 17800000 00000000 177ff42c
  0000020 177ff420 177ff400 17884000 00000000
  0000040
  ```
* u-boot执行：`hab_status`
  * 存在问题：
    ```
    => hab_status
    
    Secure boot disabled
    
    HAB Configuration: 0xf0, HAB State: 0x66
    
    --------- HAB Event 1 -----------------
    event data:
            0xdb 0x00 0x08 0x41 0x33 0x11 0xcf 0x00
    
    STS = HAB_FAILURE (0x33)
    RSN = HAB_INV_CSF (0x11)
    CTX = HAB_CTX_CSF (0xCF)
    ENG = HAB_ENG_ANY (0x00)
    
    --------- HAB Event 2 -----------------
    event data:
            0xdb 0x00 0x14 0x41 0x33 0x0c 0xa0 0x00
            0x00 0x00 0x00 0x00 0x17 0x7f 0xf4 0x00
            0x00 0x00 0x00 0x20
    
    STS = HAB_FAILURE (0x33)
    RSN = HAB_INV_ASSERTION (0x0C)
    CTX = HAB_CTX_ASSERT (0xA0)
    ENG = HAB_ENG_ANY (0x00)
    
    --------- HAB Event 3 -----------------
    event data:
            0xdb 0x00 0x14 0x41 0x33 0x0c 0xa0 0x00
            0x00 0x00 0x00 0x00 0x17 0x7f 0xf4 0x2c
            0x00 0x00 0x02 0xf0
    
    STS = HAB_FAILURE (0x33)
    RSN = HAB_INV_ASSERTION (0x0C)
    CTX = HAB_CTX_ASSERT (0xA0)
    ENG = HAB_ENG_ANY (0x00)
    
    --------- HAB Event 4 -----------------
    event data:
            0xdb 0x00 0x14 0x41 0x33 0x0c 0xa0 0x00
            0x00 0x00 0x00 0x00 0x17 0x7f 0xf4 0x20
            0x00 0x00 0x00 0x01
    
    STS = HAB_FAILURE (0x33)
    RSN = HAB_INV_ASSERTION (0x0C)
    CTX = HAB_CTX_ASSERT (0xA0)
    ENG = HAB_ENG_ANY (0x00)
    
    --------- HAB Event 5 -----------------
    event data:
            0xdb 0x00 0x14 0x41 0x33 0x0c 0xa0 0x00
            0x00 0x00 0x00 0x00 0x17 0x80 0x00 0x00
            0x00 0x00 0x00 0x04
    
    STS = HAB_FAILURE (0x33)
    RSN = HAB_INV_ASSERTION (0x0C)
    CTX = HAB_CTX_ASSERT (0xA0)
    ENG = HAB_ENG_ANY (0x00)
    ```
  * 没有问题：
    ```
    => hab_status
    
    Secure boot enabled
    
    HAB Configuration: 0xcc, HAB State: 0x99
    No HAB Events Found!
    
    =>
    ```
* After the device successfully boots a signed image without generating any HAB events, it is safe to secure, or close, the device：`fuse prog 0 6 0x2`
* U-Boot Secure Boot Log
  ```
  U-Boot 2016.03 (Jun 30 2018 - 10:32:35 +0800)
  
  CPU:   Freescale i.MX6DL rev1.3 996 MHz (running at 792 MHz)
  CPU:   Extended Commercial temperature grade (-20C to 105C) at 48C
  Reset cause: POR
  Board: MX6-SabreSD
  I2C:   ready
  DRAM:  1 GiB
  PMIC:  PFUZE100 ID=0x10
  MMC:   MMC: no card present
  MMC: no card present
  FSL_SDHC: 0, FSL_SDHC: 1, FSL_SDHC: 2
  *** Warning - bad CRC, using default environment
  
  set_panel_env error
  Display: panel800x480d18 (800x480)
  In:    serial
  Out:   serial
  Err:   serial
  config_ipu_lvds_clk: freq = 266000000.
  config_ipu_lvds_clk(35): 38791836 Hz.
  switch to partitions #0, OK
  mmc2(part 0) is current device
  Net:   FEC [PRIME]
  Error: FEC address not set.
  
  Normal Boot
  Hit any key to stop autoboot:  0
  switch to partitions #0, OK
  mmc2(part 0) is current device
  reading boot.scr
  ** Unable to read file boot.scr **
  reading zImage
  6868784 bytes read in 189 ms (34.7 MiB/s)
  Booting from mmc ...
  reading imx6dl-sabresd.dtb
  43024 bytes read in 18 ms (2.3 MiB/s)
  Kernel image @ 0x12000000 [ 0x000000 - 0x68cf30 ]
  ## Flattened Device Tree blob at 18000000
     Booting using the fdt blob at 0x18000000
  
  Authenticate image from DDR location 0x12000000...
  
  Secure boot enabled
  
  HAB Configuration: 0xcc, HAB State: 0x99
  
  --------- HAB Event 1 -----------------
  event data:
          0xdb 0x00 0x08 0x41 0x33 0x05 0x0a 0x00
  
  STS = HAB_FAILURE (0x33)
  RSN = HAB_INV_IVT (0x05)
  CTX = HAB_CTX_AUTHENTICATE (0x0A)
  ENG = HAB_ENG_ANY (0x00)
  
  Authenticate zImage Fail, Please check
  =>
  ```
