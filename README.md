# README

* OS: Ubuntu 14.04
* cst-3.0.1.tgz
* fsl_yocto-L4.1.15_2.0.0-ga.tar.gz
* Main Board: i.MX6 Development Kit
* 认证校验分为U-Boot阶段和Kernel阶段
* U-Boot阶段不需要熔断熔丝，Kernel阶段是要熔断熔丝才行的
* 一旦熔断了熔丝，那么不同的mfgtool烧录将不能下载程序，内置的启动U-Boot、Kernel也需要修改成为加密了的U-Boot、Kernel

操作的时候先参考《AN4581.pdf》生成Key，签名的时候，可以使用[linux64/csf-sign](linux64/csf-sign)来进行签名。

## 参考文档

* https://www.nxp.com/docs/en/application-note/AN4581.pdf
* https://www.nxp.com/webapp/Download?colCode=IMX_CST_TOOL&appType=license&location=null&Parent_nodeId=&Parent_pageType=
* https://www.timesys.com/security/secure-boot-encrypted-data-storage/

## MfgTool

[android_m6.0.1_2.1.0_ga_tool](https://github.com/ZengjfOS/MfgTool/tree/android6.0.1HABMfgTool)

## Sign Tool

[linux64/csf-sign](linux64/csf-sign)

使用模板的形式生成csf文件，所有需要的数据均采用动态自动生成，不再需要人工修改。

```
USAGE:
  -u specify u-boot file
  -u specify zImage file
  -g generate file
    c padding 0 with csf-uboot.bin file size to u-boot sign part
    r remove generated all file
    d dump u-boot ivt info
    z sign zImage
    mu sign MfgTool u-boot
    nu sign Normal(Typical) u-boot 
Example:
  csf-sign -g d (defalut u-boot file:u-boot.imx)
  csf-sign -g c (defalut u-boot file:u-boot.imx)
  csf-sign -g mu (defalut csf file: csf-uboot)
  csf-sign -g nu (defalut csf file: csf-uboot)
  csf-sign -g z (defalut csf file: csf-zImage)
  csf-sign -g r 
```

## Work Note

* [docs/0003_Kernel_FSL_OTP_Driver.md](docs/0003_Kernel_FSL_OTP_Driver.md)
* [docs/0002_Kernel_Secure_Boot.md](docs/0002_Kernel_Secure_Boot.md)
* [docs/0001_U-Boot_Secure_Boot.md](docs/0001_U-Boot_Secure_Boot.md)
* [Yocto MfgToo U-Boot Compile](https://github.com/ZengjfOS/Yocto/blob/master/docs/0006_MFGTool_U-Boot_In_Yocto_Receipe.md) 

## Typical U-Boot HAB Check Example

* enable U-Boot check zImage
  ```C
  uint32_t authenticate_image(uint32_t ddr_start, uint32_t image_size)
  {
      [...省略]
      // if (is_hab_enabled()) {
      if (1 == 1) {
          printf("\nAuthenticate image from DDR location 0x%x...\n",
              ddr_start);
          [...省略]
      }
      [...省略]
  }
  ```
* U-Boot Check:
  ```Shell
  U-Boot 2016.03-imx_v2016.03_4.1.15_2.0.0_ga+ga57b13b (Jul 07 2018 - 12:38:36 +0800)
  
  CPU:   Freescale i.MX6DL rev1.3 996 MHz (running at 792 MHz)
  CPU:   Extended Commercial temperature grade (-20C to 105C) at 46C
  Reset cause: POR
  Board: MX6-SabreSD
  I2C:   ready
  DRAM:  1 GiB
  PMIC:  PFUZE100 ID=0x10
  MMC:   FSL_SDHC: 0, FSL_SDHC: 1, FSL_SDHC: 2
  *** Warning - bad CRC, using default environment
  
  No panel detected: default to Hannstar-XGA
  Display: Hannstar-XGA (1024x768)
  In:    serial
  Out:   serial
  Err:   serial
  switch to partitions #0, OK
  mmc2(part 0) is current device
  Net:   FEC [PRIME]
  Error: FEC address not set.
  
  Normal Boot
  Hit any key to stop autoboot:  0
  => hab_status
  
  Secure boot disabled
  
  HAB Configuration: 0xf0, HAB State: 0x66
  No HAB Events Found!
  
  => load mmc 2 0x12000000 zImage
  reading zImage
  5603160 bytes read in 157 ms (34 MiB/s)
  => hab_auth_img 0x12000000 0x557000
  
  Authenticate image from DDR location 0x12000000...
  
  Secure boot disabled
  
  HAB Configuration: 0xf0, HAB State: 0x66
  No HAB Events Found!
  
  =>
  ```
