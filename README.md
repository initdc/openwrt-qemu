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

- Ubuntu 26.04

  ```
  sudo apt install qemu-system-arm make
  ```
- OpenWrt files https://downloads.openwrt.org/releases/24.10.5/targets/armsr/armv8/

  ```
  ls -1 openwrt* u-boot.bin

  openwrt-24.10.5-armsr-armv8-generic-ext4-rootfs.img
  openwrt-24.10.5-armsr-armv8-generic-initramfs-kernel.bin
  openwrt-24.10.5-armsr-armv8-generic-kernel.bin
  openwrt-24.10.5-armsr-armv8-generic-squashfs-combined-efi.img
  openwrt-24.10.5-armsr-armv8-generic-squashfs-rootfs.img
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
  mkdir -p test/EFI/BOOT
  cp shellaa64.efi test/EFI/BOOT/BOOTAA64.EFI

  make uefi-shell
  ```

### Guide

https://openwrt.org/docs/guide-user/virtualization/qemu

### License

MPL-2.0