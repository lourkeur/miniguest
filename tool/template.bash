source template_arg.bash

dest_dir="$_arg_dest_dir"

run_nix flake new -t github:lourkeur/miniguest "$dest_dir"
