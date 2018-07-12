# Kernel FSL OTP Driver

## 参考文档

* [How-to enable HAB in i.MX6x](https://community.nxp.com/docs/DOC-94864)

## BB file

* `cat sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/linux/linux-imx-mfgtool_4.1.15.bb`
  ```
  [...省略]
  do_configure_prepend() {
      cp ${S}/arch/arm/configs/imx_v7_mfg_defconfig ${B}/.config          # ${B} = build dir
      cp ${S}/arch/arm/configs/imx_v7_mfg_defconfig ${B}/../defconfig
  }
  [...省略]
  ```

## Build MfgTool Kernel

* make menuconfig: `cd imx6q-x11/tmp/work/imx6dlsabresd-poky-linux-gnueabi/mfgtool-linux-imx/4.1.15-r0/build && export ARCH=arm && make menuconfig`
  ```
   .config - Linux/arm 4.1.15 Kernel Configuration
   > Search (FSL_OTP) > Character devices qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    lqqqqqqqqqqqqqqqqqqqqqqqqqqq Character devices qqqqqqqqqqqqqqqqqqqqqqqqqqqk
    x  Arrow keys navigate the menu.  <Enter> selects submenus ---> (or empty x
    x  submenus ----).  Highlighted letters are hotkeys.  Pressing <Y>        x
    x  includes, <N> excludes, <M> modularizes features.  Press <Esc><Esc> to x
    x  exit, <?> for Help, </> for Search.  Legend: [*] built-in  [ ]         x
    x lqqqq^(-)qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk x
    x x    [ ]   Non-standard serial port support                           x x
    x x    < >   GSM MUX line discipline support (EXPERIMENTAL)             x x
    x x    < >   Trace data sink for MIPI P1149.7 cJTAG standard            x x
    x x    [*] /dev/mem virtual device support                              x x
    x x    [ ] /dev/kmem virtual device support                             x x
    x x        Serial drivers  --->                                         x x
    x x    < > TTY driver to output user messages via printk                x x
    x x    <*> Freescale On-Chip OTP Memory Support         <---------      x x
    x x    [ ] ARM JTAG DCC console                                         x x
    x x    < > Virtio console                                               x x
    x x    < > IPMI top-level message handler  ----                         x x
    x x    <*> Hardware Random Number Generator Core support  --->          x x
    x x    < > Siemens R3964 line discipline                                x x
    x x    < > RAW driver (/dev/raw/rawN)                                   x x
    x mqqqqv(+)qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj x
    tqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqu
    x        <Select>    < Exit >    < Help >    < Save >    < Load >         x
    mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj
  
  ```
* Build
  ```
  bitbake -f -c compile mfgtool-linux-imx
  bitbake -f -c install mfgtool-linux-imx
  bitbake -f -c deploy mfgtool-linux-imx
  ```

## MfgTool

* `cat Profiles/Linux/OS Firmware/ucl2.xml`
  ```xml
  <UCL>
    [...省略]
    <LIST name="eMMC" desc="Choose eMMC as media">
      [...省略]
      <CMD state="Updater" type="push" body="$ ls /sys"/>
      <CMD state="Updater" type="push" body="$ ls /sys/fsl_otp"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK0"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK1"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK2"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK3"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK4"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK5"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK6"/>
      <CMD state="Updater" type="push" body="$ cat /sys/fsl_otp/HW_OCOTP_SRK7"/>
      [...省略]
    </LIST>
    [...省略]
  <UCL>
  ```
* Download Output
  ```Shell
  [...省略]
  UTP: received command '$ ls /sys'
  UTP: executing "ls /sys"
  block  bus  class  dev  devices  firmware  fs  fsl_otp  kernel  module  power
  UTP: sending Success to kernel for command $ ls /sys.
  utp_poll: pass returned.
  UTP: received command '$ ls /sys/fsl_otp'
  UTP: executing "ls /sys/fsl_otp"
  HW_OCOTP_ANA0          HW_OCOTP_HDCP_KEY24  HW_OCOTP_HDCP_KEY63
  HW_OCOTP_ANA1          HW_OCOTP_HDCP_KEY25  HW_OCOTP_HDCP_KEY64
  HW_OCOTP_ANA2          HW_OCOTP_HDCP_KEY26  HW_OCOTP_HDCP_KEY65
  HW_OCOTP_CFG0          HW_OCOTP_HDCP_KEY27  HW_OCOTP_HDCP_KEY66
  HW_OCOTP_CFG1          HW_OCOTP_HDCP_KEY28  HW_OCOTP_HDCP_KEY67
  HW_OCOTP_CFG2          HW_OCOTP_HDCP_KEY29  HW_OCOTP_HDCP_KEY68
  HW_OCOTP_CFG3          HW_OCOTP_HDCP_KEY3   HW_OCOTP_HDCP_KEY69
  HW_OCOTP_CFG4          HW_OCOTP_HDCP_KEY30  HW_OCOTP_HDCP_KEY7
  HW_OCOTP_CFG5          HW_OCOTP_HDCP_KEY31  HW_OCOTP_HDCP_KEY70
  HW_OCOTP_CFG6          HW_OCOTP_HDCP_KEY32  HW_OCOTP_HDCP_KEY71
  HW_OCOTP_CRC0          HW_OCOTP_HDCP_KEY33  HW_OCOTP_HDCP_KEY8
  HW_OCOTP_CRC1          HW_OCOTP_HDCP_KEY34  HW_OCOTP_HDCP_KEY9
  HW_OCOTP_CRC2          HW_OCOTP_HDCP_KEY35  HW_OCOTP_HDCP_KSV0
  HW_OCOTP_CRC3          HW_OCOTP_HDCP_KEY36  HW_OCOTP_HDCP_KSV1
  HW_OCOTP_CRC4          HW_OCOTP_HDCP_KEY37  HW_OCOTP_HSJC_RESP1
  HW_OCOTP_CRC5          HW_OCOTP_HDCP_KEY38  HW_OCOTP_LOCK
  HW_OCOTP_CRC6          HW_OCOTP_HDCP_KEY39  HW_OCOTP_MAC0
  HW_OCOTP_CRC7          HW_OCOTP_HDCP_KEY4   HW_OCOTP_MAC1
  HW_OCOTP_DTCP_KEY0     HW_OCOTP_HDCP_KEY40  HW_OCOTP_MEM0
  HW_OCOTP_DTCP_KEY1     HW_OCOTP_HDCP_KEY41  HW_OCOTP_MEM1
  HW_OCOTP_DTCP_KEY2     HW_OCOTP_HDCP_KEY42  HW_OCOTP_MEM2
  HW_OCOTP_DTCP_KEY3     HW_OCOTP_HDCP_KEY43  HW_OCOTP_MEM3
  HW_OCOTP_DTCP_KEY4     HW_OCOTP_HDCP_KEY44  HW_OCOTP_MEM4
  HW_OCOTP_FIELD_RETURN  HW_OCOTP_HDCP_KEY45  HW_OCOTP_MISC_CONF
  HW_OCOTP_GP1           HW_OCOTP_HDCP_KEY46  HW_OCOTP_OTPMK0
  HW_OCOTP_GP2           HW_OCOTP_HDCP_KEY47  HW_OCOTP_OTPMK1
  HW_OCOTP_HDCP_KEY0     HW_OCOTP_HDCP_KEY48  HW_OCOTP_OTPMK2
  HW_OCOTP_HDCP_KEY1     HW_OCOTP_HDCP_KEY49  HW_OCOTP_OTPMK3
  HW_OCOTP_HDCP_KEY10    HW_OCOTP_HDCP_KEY5   HW_OCOTP_OTPMK4
  HW_OCOTP_HDCP_KEY11    HW_OCOTP_HDCP_KEY50  HW_OCOTP_OTPMK5
  HW_OCOTP_HDCP_KEY12    HW_OCOTP_HDCP_KEY51  HW_OCOTP_OTPMK6
  HW_OCOTP_HDCP_KEY13    HW_OCOTP_HDCP_KEY52  HW_OCOTP_OTPMK7
  HW_OCOTP_HDCP_KEY14    HW_OCOTP_HDCP_KEY53  HW_OCOTP_RESP0
  HW_OCOTP_HDCP_KEY15    HW_OCOTP_HDCP_KEY54  HW_OCOTP_SRK0
  HW_OCOTP_HDCP_KEY16    HW_OCOTP_HDCP_KEY55  HW_OCOTP_SRK1
  HW_OCOTP_HDCP_KEY17    HW_OCOTP_HDCP_KEY56  HW_OCOTP_SRK2
  HW_OCOTP_HDCP_KEY18    HW_OCOTP_HDCP_KEY57  HW_OCOTP_SRK3
  HW_OCOTP_HDCP_KEY19    HW_OCOTP_HDCP_KEY58  HW_OCOTP_SRK4
  HW_OCOTP_HDCP_KEY2     HW_OCOTP_HDCP_KEY59  HW_OCOTP_SRK5
  HW_OCOTP_HDCP_KEY20    HW_OCOTP_HDCP_KEY6   HW_OCOTP_SRK6
  HW_OCOTP_HDCP_KEY21    HW_OCOTP_HDCP_KEY60  HW_OCOTP_SRK7
  HW_OCOTP_HDCP_KEY22    HW_OCOTP_HDCP_KEY61  HW_OCOTP_SRK_REVOKE
  HW_OCOTP_HDCP_KEY23    HW_OCOTP_HDCP_KEY62
  UTP: sending Success to kernel for command $ ls /sys/fsl_otp.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK0'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK0"
  0x442024e5
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK0.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK1'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK1"
  0x73343e75
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK1.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK2'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK2"
  0xf83d526e
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK2.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK3'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK3"
  0xa8c56a62
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK3.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK4'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK4"
  0x58dd8f6f
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK4.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK5'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK5"
  0x60400336
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK5.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK6'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK6"
  0xa62bc0d8
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK6.
  utp_poll: pass returned.
  UTP: received command '$ cat /sys/fsl_otp/HW_OCOTP_SRK7'
  UTP: executing "cat /sys/fsl_otp/HW_OCOTP_SRK7"
  0x1e950925
  UTP: sending Success to kernel for command $ cat /sys/fsl_otp/HW_OCOTP_SRK7.
  [...省略]
  ```
