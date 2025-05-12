#!/bin/bash

# Declare associative array (only works in Bash 4+)
declare -A plugins=(
  ["telescope.nvim"]="https://github.com/nvim-telescope/telescope.nvim"
  ["plenary.nvim"]="https://github.com/nvim-lua/plenary.nvim"
  ["popup.nvim"]="https://github.com/nvim-lua/popup.nvim"
  ["nvim-web-devicons"]="https://github.com/nvim-tree/nvim-web-devicons"
  ["neogit"]="https://github.com/xsoder/neogit"
  ["buffer-manager"]="https://github.com/xsoder/buffer-manager.nvim"
  ["fzf-lua"]="https://github.com/ibhagwan/fzf-lua"
)

# Target installation directory
install_dir="$HOME/.local/share/nvim/site/pack/himadri/start"

# Create directory if it doesn't exist
mkdir -p "$install_dir"

# Loop through the array and clone each plugin
for name in "${!plugins[@]}"; do
  url="${plugins[$name]}"
  target="$install_dir/$name"
  
  if [ -d "$target" ]; then
    echo "$name already exists at $target, skipping..."
  else
    echo "Cloning $name from $url..."
    git clone "$url" "$target"
  fi
done

