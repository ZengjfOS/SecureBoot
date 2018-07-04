# Kernel Secure Boot 

## 参考文档

* [Is it possible to have fat file write support in the Uboot 2009.11 version.](https://community.nxp.com/thread/352285)
* [how to change boot partiton on u-boot-fslc branch patches-2014.07?](https://community.nxp.com/thread/331306)
* [rescuing a broken secure boot enabled i.mx6](http://www.edlangley.co.uk/blog/2014/06/rescuing-bricked-secure-mode-i.mx6/)
* [How to recover the closed-configuration device been tampered](https://community.nxp.com/thread/465919)

## 操作流程

* 修改U-Boot支持不close Fuse也能校验：
  ```
  uint32_t authenticate_image(uint32_t ddr_start, uint32_t image_size)
  {
      uint32_t load_addr = 0;
      size_t bytes;
      ptrdiff_t ivt_offset = 0;
      int result = 0;
      ulong start;
      hab_rvt_authenticate_image_t *hab_rvt_authenticate_image;
      hab_rvt_entry_t *hab_rvt_entry;
      hab_rvt_exit_t *hab_rvt_exit;
  
      hab_rvt_authenticate_image = hab_rvt_authenticate_image_p;
      hab_rvt_entry = hab_rvt_entry_p;
      hab_rvt_exit = hab_rvt_exit_p;
  
      // if (is_hab_enabled()) {        <---------------------- modify
      if ( 1 == 1) {
          printf("\nAuthenticate image from DDR location 0x%x...\n",
              ddr_start);
  
          hab_caam_clock_enable(1);
  
     [...省略]
  }
  ```
* U-Boot校验内核：
  ```
  => load mmc 2 0x10008000 zImage
  reading zImage
  6868784 bytes read in 188 ms (34.8 MiB/s)
  =>  hab_auth_img 0x10008000 0x66C000
  
  Authenticate image from DDR location 0x10008000...
  
  Secure boot enabled
  
  HAB Configuration: 0xcc, HAB State: 0x99
  
  --------- HAB Event 1 -----------------
  event data:
          0xdb 0x00 0x08 0x41 0x33 0x05 0x0a 0x00
  
  STS = HAB_FAILURE (0x33)
  RSN = HAB_INV_IVT (0x05)
  CTX = HAB_CTX_AUTHENTICATE (0x0A)
  ENG = HAB_ENG_ANY (0x00)
  => load mmc 1 0x10008000 zImage
  reading zImage
  6737752 bytes read in 325 ms (19.8 MiB/s)
  => hab_auth_img 0x10008000 0x66C000
  
  Authenticate image from DDR location 0x10008000...
  
  Secure boot disabled
  
  HAB Configuration: 0xf0, HAB State: 0x66
  No HAB Events Found!
  
  =>
  ```

## Make SD load zImage

* [mksdcard.sh](docs/mksdcard.sh)
* 查看挂载点：`sudo fdisk -l`
* 获取FAT格式盘：`sudo ./mksdcard.sh /dev/sdb`
* 在Windows下格式化FAT盘，并将加密的`zImage`拷贝进去
* U-Boot加载`zImage`，并校验
  ```
  => load mmc 1 0x10008000 zImage
  reading zImage
  6737752 bytes read in 325 ms (19.8 MiB/s)
  => hab_auth_img 0x10008000 0x66C000
  
  Authenticate image from DDR location 0x10008000...
  
  Secure boot enabled
  
  HAB Configuration: 0xcc, HAB State: 0x99
  No HAB Events Found!
  
  =>
  ```
* 对比load和save用法：
  * `load <interface> [<dev[:part]> [<addr> [<filename> [bytes [pos]]]]]`
  * `save <interface> <dev[:part]> <addr> <filename> bytes [pos]`
* 重新编译U-Boot支持save FAT盘功能：`CONFIG_FAT_WRITE` -Define this to enable support for saving
  ```
  CONFIG_ARM=y
  CONFIG_ARCH_MX6=y
  CONFIG_TARGET_MX6SABRESD=y
  CONFIG_SYS_EXTRA_OPTIONS="IMX_CONFIG=board/freescale/mx6sabresd/mx6dlsabresd.cfg,MX6DL,SYS_USE_SPINOR,FAT_WRITE"
  CONFIG_CMD_GPIO=y
  ```
* zImage Write To FAT Filesystem
  ```
  => save mmc 1 0x10008000 zImage.new 66CF58
  writing zImage.new
  6737752 bytes written in 2069 ms (3.1 MiB/s)
  => save mmc 2 0x10008000 zImage 66CF58
  writing zImage
  6737752 bytes written in 716 ms (9 MiB/s)
  ```

## Burning U-Boot

* fat load u-boot
  ```
  => fatload mmc 1 0x10008000 u-boot.imx                # 加载sd卡中的u-boot.imx
  reading u-boot.imx
  555832 bytes read in 41 ms (12.9 MiB/s)
  => mmc partconf 2 1 0 1                               # 使能u-boot存储分区写入
  => mmc dev 2                                          # 进入eMMC对应的设备u-boot存放分区
  switch to partitions #0, OK
  mmc2(part 0) is current device
  => mmc part
  
  Partition Map for MMC device 2  --   Partition Type: DOS
  
  Part    Start Sector    Num Sectors     UUID            Type
    1     20480           1024000         00000000-01     0c
    2     1228800         6504448         00000000-02     83
  => mmc write 0x10008000 0x2 0x43E                     # 将内存中的u-boot.imx写入eMMC中去
  
  MMC write: dev # 2, block # 2, count 555832 ... 555832 blocks written: OK
  =>
  ```
* MFGTool 
  ```
  ModuleID[2] LevelID[10]: *********MxHidDevice[05CD0518] Jump to Ramkernel successfully!**********
  ModuleID[2] LevelID[10]: CmdOperation[0], current state command has been finished and the last command is successful, so SetEvent(hDevCanDeleteEvent)
  ModuleID[2] LevelID[10]: CmdOperation[0] device chagned and reset to state 0
  ModuleID[2] LevelID[10]: CmdOperation[0], skip current command, so SetEvent(hDevCanDeleteEvent)
  ModuleID[2] LevelID[10]: ExecuteCommand--Boot[WndIndex:0], File is D:\MfgTool\Profiles\linux\OS Firmware\firmware\u-boot-imx6dlsabresd_sd.imx
  ModuleID[2] LevelID[1]: WriteReg(): Invalid write ack: 0xc0183304
  
  ModuleID[2] LevelID[1]: Failed to initialize memory!
  ModuleID[2] LevelID[1]: PortMgrDlg(0)--MxHidDevice--Command Boot excute failed
  ModuleID[2] LevelID[10]: CmdOperation[0], current command executed failed, so SetEvent(hDevCanDeleteEvent)
  ```
