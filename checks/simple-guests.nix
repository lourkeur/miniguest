inputs@{ self, nixpkgs, ... }: system:

with nixpkgs.lib;
let
  kvm_guest = nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.miniguest
      {
        boot.miniguest.enable = true;
        fileSystems."/" = {
          device = "none";
          fsType = "tmpfs";
          options = [ "defaults" "mode=755" ];
        };
      }
    ];
  };
  lxc_guest = nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.miniguest
      {
        boot.miniguest.enable = true;
        boot.miniguest.guestType = "lxc";
        boot.miniguest.storeCorruptionWarning = false;
      }
    ];
  };
in
with nixpkgs.legacyPackages.${system};
optionalAttrs stdenv.isLinux {
  build_kvm_guest = kvm_guest.config.system.build.miniguest;
  build_lxc_guest = lxc_guest.config.system.build.miniguest;
}