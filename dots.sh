dotfiles=(
    "$HOME/.dotfiles/GIMP:$HOME/.config/GIMP"
    "$HOME/.dotfiles/btop:$HOME/.config/btop"
    "$HOME/.dotfiles/darktable:$HOME/.config/darktable"
    "$HOME/.dotfiles/dunst:$HOME/.config/dunst"
    "$HOME/.dotfiles/fastfetch:$HOME/.config/fastfetch"
    "$HOME/.dotfiles/flameshot:$HOME/.config/flameshot"
    "$HOME/.dotfiles/gh:$HOME/.config/gh"
    "$HOME/.dotfiles/git:$HOME/.config/git"
    "$HOME/.dotfiles/i3:$HOME/.config/i3"
    "$HOME/.dotfiles/lazygit:$HOME/.config/lazygit"
    "$HOME/.dotfiles/mpv:$HOME/.config/mpv"
    "$HOME/.dotfiles/paru:$HOME/.config/paru"
    "$HOME/.dotfiles/pcmanfm:$HOME/.config/pcmanfm"
    "$HOME/.dotfiles/pikaur:$HOME/.config/pikaur"
    "$HOME/.dotfiles/qimgv:$HOME/.config/qimgv"
    "$HOME/.dotfiles/rofi:$HOME/.config/rofi"
    "$HOME/.dotfiles/wezterm:$HOME/.config/wezterm"

    "$HOME/.dotfiles/okularrc:$HOME/.config/okularrc"
    "$HOME/.dotfiles/okularpartrc:$HOME/.config/okularpartrc"
    "$HOME/.dotfiles/starship.toml:$HOME/.config/starship.toml"
    "$HOME/.dotfiles/greenclip.toml:$HOME/.config/greenclip.toml"

    "$HOME/.dotfiles/.profile:$HOME/.profile"
    #    "$HOME/.dotfiles/.bashrc:$HOME/.bashrc" I shifted to my config of ohmybash
    #    "$HOME/.dotfiles/.zshrc:$HOME/.zshrc" Might not be using zsh now
    "$HOME/.dotfiles/.tmux.conf:$HOME/.tmux.conf"
    "$HOME/.dotfiles/.vimrc:$HOME/.vimrc"
)

echo "Linking dotfiles..."
for entry in "${dotfiles[@]}"; do
    src="${entry%%:*}"
    tgt="${entry##*:}"
    echo "Linking $src → $tgt"
    rm -rf $tgt
    ln -sf "$src" "$tgt"
done
