{ ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.timeout = 0;

  boot.initrd.availableKernelModules = [
    "virtio_pci" "virtio_scsi" "virtio_blk" "virtio_net" "virtio_balloon" "virtio_console"
  ];
}
