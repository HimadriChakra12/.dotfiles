# --- Bash compatibility (important) ---
setopt KSH_ARRAYS
setopt SH_WORD_SPLIT
setopt PROMPT_SUBST

# Increase the history size and avoid duplicates
HISTSIZE=10000
SAVEHIST=10000
HISTIGNORE="&:ls:ps:cd:pwd:exit"
setopt hist_ignore_dups  # Don't store duplicate entries in history
setopt hist_save_no_dups  # Don't save duplicates in the history file
setopt hist_reduce_blanks  # Remove redundant blanks from history
setopt append_history  # Append to history rather than overwriting
setopt share_history  # Share history between all sessions

# --- Completion system ---
autoload -Uz compinit
compinit
setopt nonomatch
# Enable history completion
bindkey "^R" history-incremental-search-backward
# Use history for command-line autocomplete
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Completion UX (clean, powerful)
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{blue}%d%f'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/.zcompcache
# ~/.zshrc

fastfetch
# ============================
# Environment / PATH
# ============================
export APP="$HOME/.local/share/applications"
export PATH="$HOME/sayarchi/scripts:$HOME/sayarchi/bin:$HOME/.dotfiles:$HOME/Music:$HOME/.local/bin:$PATH"

# ============================
# Interactive check
# ============================
[[ $- != *i* ]] && return  # exit if not interactive

# ============================
# Completions and prompt
# ============================
# zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# FZF completion
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

# ============================
# Aliases
# ============================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias paci="sudo pacman -S"
alias pacs="sudo pacman -q"
alias yi="yay -S"
alias pi="pikaur -S"
alias ys="yay -q"
alias pks="pikaur -q"
alias update="yay"
alias exp="nvim $PWD"
alias Exp="pcmanfm $PWD & disown"
alias ep="nvim ~/.zshrc"
alias sour="source ~/.zshrc"
alias i="sudo pacman -S"
alias v="nvim"
alias nano="nvim"
alias q="exit"
alias c="clear"
alias gg="nvim -c Git"
alias fst="fastfetch"
alias reset="rm ~/.cache/app_launcher_cache"
alias czf="fzf --layout=reverse --header 'selector' --height 50%"

# ============================
# eza / ls aliases
# ============================
if command -v eza &> /dev/null; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
    alias l='lt -lh -T -L 2'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# ============================
# Functions
# ============================

# pb: pick a file to open in vim
pb() {
    local file
    file=$(fzf) || return
    vim "$file"
}


# zo: recursive fuzzy directory picker
zo() {
    local items selected_item
    items=("..")
    while IFS= read -r line; do
        items+=("$line")
    done < <(ls -1)
    selected_item=$(printf '%s\n' "${items[@]}" | fzf --layout=reverse --header "$(pwd)" --height 90% --preview "eza --color=always {} -T") || return
    if [ -n "$selected_item" ]; then
        if [ -d "$selected_item" ]; then
            cd "$selected_item" || return
            zo
        else
            xdg-open "$selected_item" &>/dev/null &
        fi
    fi
}

# clean_packages: remove orphaned packages and optionally clear cache
clean_packages() {
    read -q "opt?Wanna Clean Packages With config? [y/n] "
    echo
    if [[ $opt == [yY] || $opt == yes ]]; then
        sudo pacman -Rns $(pacman -Qdtq)
    else
        sudo pacman -Rs $(pacman -Qdtq)
    fi
    read -q "cache?Wanna Clean Caches? [y/n] "
    echo
    if [[ $cache == [yY] || $cache == yes ]]; then
        sudo pacman -Scc
    fi
}

# open: open files with default app
open() {
    xdg-open "$@" >/dev/null 2>&1 &
}

# fs: grep in current directory
fs() {
    ls | grep "$@"
}

# cx: chmod +x on selected file via fzf
cx() {
    chmod +x "$(fzf)" || return
}

# gcl: clone a GitHub repo interactively
gcl() {
    local repo
    repo=$(gh repo list --limit 100 --json name --jq '.[].name' | fzf) || return
    cd ~/git || return
    git clone "https://github.com/HimadriChakra12/$repo"
    cd "$repo" || return
}

# gogit: open file from repo interactively
gogit() {
    local dir file
    dir=$(ls ~/.git | fzf) || return
    cd ~/.git/"$dir" || return
    file=$(fzf) || return
    nvim "$file"
}

# installtar: build and install AUR tarballs
installtar() {
    local tarfile="$1" tempdir
    if [ -z "$tarfile" ]; then
        echo "Usage: installtar <file.tar.gz|tar.xz|tar.zst|tar.bz2>"
        return 1
    fi
    if [ ! -f "$tarfile" ]; then
        echo "File not found: $tarfile"
        return 1
    fi

    tempdir=$(mktemp -d /tmp/aurbuild.XXXXXX)
    cp "$tarfile" "$tempdir"
    cd "$tempdir" || return 1

    case "$tarfile" in
        *.tar.gz)  tar -xzf "$(basename "$tarfile")" ;;
        *.tar.xz)  tar -xJf "$(basename "$tarfile")" ;;
        *.tar.zst) tar --use-compress-program=unzstd -xf "$(basename "$tarfile")" ;;
        *.tar.bz2) tar -xjf "$(basename "$tarfile")" ;;
        *) echo "Unsupported file type."; rm -rf "$tempdir"; return 1 ;;
    esac

    cd */ || { echo "Could not enter extracted folder."; rm -rf "$tempdir"; return 1; }

    if [ -f PKGBUILD ]; then
        makepkg -si --noconfirm
        local result=$?
        rm -rf "$tempdir"
        return $result
    else
        echo "No PKGBUILD found. Cannot build."
        rm -rf "$tempdir"
        return 1
    fi
}

# flac: download audio as FLAC from URL
flac() {
    read -r "filename?Name of the song: "
    read -r "url?Enter the URL: "
    yt-dlp -f bestaudio --extract-audio --audio-format flac --audio-quality 0 -o "~/Music/${filename}.flac" "$url"
}

# mg: make a script global
mg() {
    if [ -z "$1" ]; then
        echo "Usage: makeglobal <script_path> [new_name]"
        return 1
    fi
    local SCRIPT="$1"
    local NAME="${2:-$(basename "$SCRIPT")}"
    local DEST="$HOME/bin/$NAME"

    mkdir -p "$HOME/bin"
    if cp "$SCRIPT" "$DEST"; then
        chmod +x "$DEST"
        echo "✅ Script is now global as: $NAME"
    else
        echo "❌ Failed to copy '$SCRIPT' to '$DEST'"
        return 1
    fi
}

# reg: escape URL as regex
reg() {
    local url="$1"
    if [ -z "$url" ]; then
        echo "Usage: $0 <url>"
        return 1
    fi
    printf '^%s$\n' "$(printf '%s' "$url" | sed -e 's/[.[\*^$()+?{|]/\\&/g' -e 's/\\/\\\\/g')"
}

# ez: extract archive interactively
ez() {
    local archive dir
    archive=$(find . -maxdepth 1 -type f \
        \( -iname "*.zip" -o -iname "*.7z" -o -iname "*.rar" -o -iname "*.tar" -o -iname "*.tar.gz" -o -iname "*.tgz" \) \
        | fzf) || return
    dir="${archive%.*}"
    mkdir -p "$dir"
    7z x "$archive" -o"$dir"
}

# mkcd: make dir and cd
mkcd() {
    local location="$1"
    if [ -z "$location" ]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -p "$location" && cd "$location" || return
    pwd
}

# gc: set git global config
gc() {
    git config --global user.name "$1"
    git config --global user.email "$2"
}

# mountit: mount ISO or image
mountit() {
    local file="$1" name="$2"
    mkdir -p "/mnt/$name"
    sudo mount -o loop,ro "$file" "/mnt/$name"
}

# ============================
# Status / Extras
# ============================
# Example: show active key table in WezTerm (if used)
# wezterm.on("update-right-status", function(window, pane)
#   ...
# end)

# End of .zshrc

