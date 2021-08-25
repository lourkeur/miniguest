# Installation guide
First, you will need the Nix package manager.  Installation instructions can be
found [here](https://nixos.org/manual/nix/stable#chap-installation).

Next, the miniguest tool can be installed with
```sh
git clone https://github.com/lourkeur/miniguest
nix-env -if ./miniguest
```

Alternatively, if you use [Nix flakes](https://nixos.wiki/wiki/Flakes) you
should run
```sh
nix profile install github:lourkeur/miniguest
```

A Nixpkgs overlay is also available
```nix
(import (builtins.fetchGit https://github.com/lourkeur/miniguest)).overlay
```
