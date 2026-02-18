ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

define EXTRA_ARG
-device virtio-net,netdev=net0 -netdev user,id=net0,net=192.168.1.0/24,hostfwd=tcp::8080-:80 \
-device virtio-net,netdev=net1 -netdev user,id=net1,net=100.0.0.0/24
endef

initramfs:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-kernel $(shell find openwrt-*-initramfs-kernel.bin) \
	-drive if=none,file=$(shell find openwrt-*-squashfs-rootfs.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

recovery:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-kernel $(shell find openwrt-*-initramfs-kernel.bin) \
	$(EXTRA_ARG)

squashfs:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-kernel $(shell find openwrt-*-generic-kernel.bin) \
	-append "root=fe00" \
	-drive if=none,file=$(shell find openwrt-*-squashfs-rootfs.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

ext4:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-kernel $(shell find openwrt-*-generic-kernel.bin) \
	-append "root=fe00" \
	-drive if=none,file=$(shell find openwrt-*-ext4-rootfs.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

uboot:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-bios u-boot.bin \
	-kernel $(shell find openwrt-*-generic-kernel.bin) \
	-append "root=fe00" \
	-drive if=none,file=$(shell find openwrt-*-squashfs-rootfs.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

efi:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-drive if=pflash,format=raw,readonly=on,file=QEMU_EFI_64M.fd \
	-drive if=pflash,format=raw,file=varstore.img \
	-drive if=none,file=$(shell find openwrt-*-squashfs-combined-efi.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

# press ESC or F2 to enter bios
edk2:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-drive if=pflash,format=raw,readonly=on,file=QEMU_EFI_64M.fd \
	-drive if=pflash,format=raw,file=varstore.img \
	-boot menu=on,splash-time=30000

uefi-shell:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-drive if=pflash,format=raw,readonly=on,file=QEMU_EFI_64M.fd \
	-drive if=pflash,format=raw,file=varstore.img \
	-drive file=fat:rw:edk2

uboot-env:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-bios u-boot.bin \
 	-device loader,file=u-boot/boot.scr,addr=0x40200000 \
	-drive file=fat:rw:u-boot \
	-drive if=none,file=$(shell find openwrt-*-squashfs-rootfs.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

uboot-efi:
	qemu-system-aarch64 -m 1024 -smp 2 -cpu cortex-a57 -M virt -nographic \
	-bios u-boot.bin \
	-drive if=none,file=$(shell find openwrt-*-squashfs-combined-efi.img),id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	$(EXTRA_ARG)

parted-list:
	parted $(ARGS) unit MiB print

boot.src:
	mkimage -A arm64 -O linux -T script -C none \
	-d u-boot/boot.txt u-boot/boot.scr