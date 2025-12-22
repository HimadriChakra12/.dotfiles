dotfiles=(
    "$HOME/.dotfiles/dunst:$HOME/dunst"
    "$HOME/.dotfiles/gh:$HOME/gh"
    "$HOME/.dotfiles/i3:$HOME/i3"
    "$HOME/.dotfiles/lazygit:$HOME/lazygit"
    "$HOME/.dotfiles/mpv:$HOME/mpv"
    "$HOME/.dotfiles/nvim:$HOME/nvim"
    "$HOME/.dotfiles/paru:$HOME/paru"
    "$HOME/.dotfiles/pikaur:$HOME/pikaur"
    "$HOME/.dotfiles/qimgv:$HOME/qimgv"
    "$HOME/.dotfiles/rofi:$HOME/rofi"
    "$HOME/.dotfiles/wezterm:$HOME/wezterm"
    "$HOME/.dotfiles/git:$HOME/git"
    "$HOME/.dotfiles/.bashrc:$HOME/.bashrc"
    "$HOME/.dotfiles/.tmux.conf:$HOME/.tmux.conf"
)

echo "Linking dotfiles..."
for entry in "${dotfiles[@]}"; do
    src="${entry%%:*}"
    tgt="${entry##*:}"
    echo "Linking $src → $tgt"
    rm "$tgt" -r
    ln -sf "$src" "$tgt"
done

