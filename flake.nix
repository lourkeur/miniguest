# Copyright 2021 Louis Bettens
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

{
  description = "guest NixOS images with minimal footprint";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs@{ self, nixpkgs, devshell, flake-utils }:
    with flake-utils.lib;
    let
      overlay = import miniguest/overlay.nix;
    in
    {
      nixosModules.miniguest = import modules/miniguest.nix;
      inherit overlay;
      defaultTemplate = {
        description = "Example guest configurations";
        path = ./template;
      };
    } // eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
      in
      {
        packages.miniguest = pkgs.miniguest;
        defaultPackage = pkgs.miniguest;
        defaultApp = mkApp { drv = pkgs.miniguest; };
        devShell = devshell.legacyPackages.${system}.fromTOML ./devshell.toml;
        checks = import ./checks inputs system;
      });
}
