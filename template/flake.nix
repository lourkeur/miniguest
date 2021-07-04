{
  description = "My Miniguest guests";

  inputs = {
    nixos.url = "nixpkgs/nixos-unstable";
    miniguest.url = "github:lourkeur/miniguest";
    miniguest.inputs.nixpkgs.follows = "nixos";
  };

  outputs = { self, miniguest, nixos }:
    with nixos.lib; {
      nixosConfigurations = attrsets.genAttrs [ "stateless" ] (name:
        nixosSystem {
          system = "x86_64-linux";
          modules = [ miniguest.nixosModules.miniguest (./guests + "/${name}") ];
        });
    };
}
