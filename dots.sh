dotfiles=(
    "$HOME/.dotfiles/dunst:$HOME/.config/dunst"
    "$HOME/.dotfiles/gh:$HOME/.config/gh"
    "$HOME/.dotfiles/i3:$HOME/.config/i3"
    "$HOME/.dotfiles/lazygit:$HOME/.config/lazygit"
    "$HOME/.dotfiles/mpv:$HOME/.config/mpv"
    "$HOME/.dotfiles/nvim:$HOME/.config/nvim"
    "$HOME/.dotfiles/paru:$HOME/.config/paru"
    "$HOME/.dotfiles/pikaur:$HOME/.config/pikaur"
    "$HOME/.dotfiles/qimgv:$HOME/.config/qimgv"
    "$HOME/.dotfiles/rofi:$HOME/.config/rofi"
    "$HOME/.dotfiles/wezterm:$HOME/.config/wezterm"
    "$HOME/.dotfiles/git:$HOME/.config/git"
    "$HOME/.dotfiles/.bashrc:$HOME/.bashrc"
    "$HOME/.dotfiles/.tmux.conf:$HOME/.tmux.conf"
)

echo "Linking dotfiles..."
for entry in "${dotfiles[@]}"; do
    src="${entry%%:*}"
    tgt="${entry##*:}"
    echo "Linking $src → $tgt"
    ln -sf "$src" "$tgt"
done

