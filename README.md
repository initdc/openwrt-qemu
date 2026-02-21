## OpenWrt in QEMU

### Run

```
make squashfs
```

### Exit
```sh
poweroff

# or new shell
pkill -f qemu-system-aarch64
```

### Prepare

- Ubuntu 24.04 (GNU coreutils for building OpenWrt) or Ubuntu 26.04 (for qemu 10 RVA23)

  ```
  sudo apt install qemu-system-arm make u-boot-tools
  ```
- OpenWrt files https://downloads.openwrt.org/releases/24.10.5/targets/armsr/armv8/

  ```
  ls -1 openwrt* u-boot.bin

  openwrt-24.10.5-armsr-armv8-generic-ext4-rootfs.img
  openwrt-24.10.5-armsr-armv8-generic-initramfs-kernel.bin
  openwrt-24.10.5-armsr-armv8-generic-kernel.bin
  openwrt-24.10.5-armsr-armv8-generic-squashfs-combined-efi.img
  openwrt-24.10.5-armsr-armv8-generic-squashfs-rootfs.img
  openwrt-24.10.5-armsr-armv8-rootfs.cpio.gz
  u-boot.bin
  ```

- EFI files

  ```
  cp /usr/share/qemu-efi-aarch64/QEMU_EFI.fd QEMU_EFI_64M.fd
  truncate -s 64M QEMU_EFI_64M.fd
  truncate -s 64M varstore.img
  ```

- UEFI Shell https://github.com/pbatard/UEFI-Shell

  ```
  mkdir -p edk2/EFI/BOOT
  cp shellaa64.efi edk2/EFI/BOOT/BOOTAA64.EFI

  make uefi-shell
  ```

- U-Boot `boot.scr` (as a disk partition)

  ```sh
  mkdir -p u-boot/boot
  cp openwrt-24.10.5-armsr-armv8-generic-kernel.bin u-boot/boot/Image
  touch u-boot/boot.txt
  ```

  edit `u-boot/boot.txt`
  ```sh
  fatload virtio 1 ${kernel_addr_r} /boot/Image
  setenv bootargs root=fe00
  booti ${kernel_addr_r} - ${fdt_addr}
  ```

  ```sh
  make boot.scr
  make uboot-env

  # enter u-boot
  source ${scriptaddr}
  ```

  U-Boot `.CONFIG`
  ```sh
  CONFIG_BOOTCOMMAND="source ${scriptaddr}"
  ```

### Network Boot

- [Network Boot](network-boot.md)

### Guide

- https://openwrt.org/docs/guide-user/virtualization/qemu
- https://linuxkernel.org.cn/doc/html/latest/admin-guide/nfs/nfsroot.html
- https://linuxkernel.org.cn/doc/html/latest/filesystems/ramfs-rootfs-initramfs.html
- https://linuxkernel.org.cn/doc/html/latest/admin-guide/initrd.html

### License

MPL-2.0