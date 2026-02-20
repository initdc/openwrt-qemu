## Network Boot

### Prepare

  Rebuild the [kernel](https://github.com/initdc/openwrt-qemu/releases) which should support `/dev/ram0`

  ```sh
  CONFIG_BLK_DEV_RAM=y
  CONFIG_BLK_DEV_RAM_COUNT=16
  CONFIG_BLK_DEV_RAM_SIZE=4096 # change size as you need
  ```

  ```sh
  export ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-

  make defconfig
  make menuconfig
  make Image -j$(nproc)

  file arch/arm64/boot/Image
  Image: Linux kernel ARM64 boot executable Image, little-endian, 4K pages
  ```

### Run and test

  then `make tftp`

  ```sh
  # enter u-boot
  dhcp

  tftp ${kernel_addr_r} Image
  tftp ${ramdisk_addr_r} openwrt-24.10.5-armsr-armv8-rootfs.cpio.gz

  setenv bootargs root=/dev/ram0
  booti ${kernel_addr_r} ${ramdisk_addr_r}:${filesize} ${fdtcontroladdr}
  ```

  you can compile it as `boot.scr`, then `make tftp-env`
