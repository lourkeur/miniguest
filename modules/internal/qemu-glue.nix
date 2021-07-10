{ config, lib, ... }:

# Mix-in for a QEMU or KVM mini-guest.

with lib;
let
  cfg = config.boot.miniguest;
in
mkIf (cfg.enable && cfg.hypervisor == "qemu") {
  fileSystems."/boot" = {
    device = "boot";
    fsType = "9p";
    neededForBoot = true;
  };

  fileSystems."/nix/store" = {
    device = "nix-store";
    fsType = "9p";
  };

  boot.initrd.postMountCommands = ''
    cp -PT /mnt-root/boot/init /mnt-root/init
  '';

  boot.loader.grub.enable = mkDefault false;
}