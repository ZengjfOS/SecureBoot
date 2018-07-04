# README

* OS: Ubuntu 14.04
* cst-3.0.1.tgz
* fsl_yocto-L4.1.15_2.0.0-ga.tar.gz
* Main Board: i.MX6 Development Kit
* 认证校验分为U-Boot阶段和Kernel阶段
* U-Boot阶段不需要熔断熔丝，Kernel阶段是要熔断熔丝才行的
* 一旦熔断了熔丝，那么不同的mfgtool烧录将不能下载程序，内置的启动U-Boot、Kernel也需要修改成为加密了的U-Boot、Kernel

操作的时候先参考《AN4581.pdf》生成Key，签名的时候，可以使用[linux64/csf-sign](linux64/csf-sign)来进行签名。

# 参考文档

* https://www.nxp.com/docs/en/application-note/AN4581.pdf
* https://www.nxp.com/webapp/Download?colCode=IMX_CST_TOOL&appType=license&location=null&Parent_nodeId=&Parent_pageType=

## Sign Tool

[linux64/csf-sign](linux64/csf-sign)

```
USAGE:
  -u specify u-boot file
  -u specify zImage file
  -g generate file
    c padding 0 with csf-uboot.bin file size to u-boot sign part
    r remove generate all file
    d dump u-boot ivt info
    z sign zImage
    mu sign MfgTool u-boot
    nu sign normal u-boot 
Example:
  csf-sign -g d (defalut u-boot file:u-boot.imx)
  csf-sign -g c (defalut u-boot file:u-boot.imx)
  csf-sign -g mu (defalut csf file: csf-uboot)
  csf-sign -g nu (defalut csf file: csf-uboot)
  csf-sign -g z (defalut csf file: csf-zImage)
  csf-sign -g r (defalut csf file: csf-zImage)
```

## Work Note

* [docs/0002_Kernel_Secure_Boot.md](docs/0002_Kernel_Secure_Boot.md)
* [docs/0001_U-Boot_Secure_Boot.md](docs/0001_U-Boot_Secure_Boot.md)
