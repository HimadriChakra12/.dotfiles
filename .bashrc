#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

tmux attach
tmux
alias t="tmux"
alias ta="tmux attach"
alias paci="sudo pacman -S"
alias pacs="sudo pacman -q"
alias yi="yay -S"
alias pi="pikaur -S"
alias ys="yay -q"
alias pks="pikaur -q"
alias ep="nvim ~/.bashrc"
alias v="nvim"
alias q="exit"
alias c="clear"
alias gg="lazygit"
alias update="yay"
alias sour="source ~/.bashrc"
gcl(){
	repo=$(gh repo list --limit 100 --json name --jq '.[].name' | fzf)
	cd ~/.git
	git clone https://github.com/HimadriChakra12/$repo
	cd $repo

}
gogit(){
	dir=$(ls ~/.git| fzf)
	cd ~/.git/$dir
	file=$(fzf)
	nvim $file
}
iinstalltar() {
  local tarfile="$1"
  local tempdir
  tempdir="$(mktemp -d /tmp/aurbuild.XXXXXX)"

  if [[ -z "$tarfile" ]]; then
    echo "Usage: installtar <file.tar.gz|tar.xz|tar.zst|tar.bz2>"
    return 1
  fi

  if [[ ! -f "$tarfile" ]]; then
    echo "File not found: $tarfile"
    return 1
  fi

  echo "Copying $tarfile to $tempdir"
  cp "$tarfile" "$tempdir"
  cd "$tempdir" || return 1

  # Extract based on file type
  case "$tarfile" in
    *.tar.gz)  tar -xzf "$(basename "$tarfile")" ;;
    *.tar.xz)  tar -xJf "$(basename "$tarfile")" ;;
    *.tar.zst) tar --use-compress-program=unzstd -xf "$(basename "$tarfile")" ;;
    *.tar.bz2) tar -xjf "$(basename "$tarfile")" ;;
    *) echo "Unsupported file type."; rm -rf "$tempdir"; return 1 ;;
  esac

  # Enter extracted directory
  cd */ || { echo "Could not enter extracted folder."; rm -rf "$tempdir"; return 1; }

  if [[ -f PKGBUILD ]]; then
    echo "Building and installing..."
    makepkg -si --noconfirm
    local result=$?
    echo "Cleaning up..."
    rm -rf "$tempdir"
    return $result
  else
    echo "No PKGBUILD found. Cannot build."
    rm -rf "$tempdir"
    return 1
  fi
}
installtar() {
  local tarfile="$1"
  local tempdir
  tempdir="$(mktemp -d /tmp/aurbuild.XXXXXX)"

  if [[ -z "$tarfile" ]]; then
    echo "Usage: installtar <file.tar.gz|tar.xz|tar.zst|tar.bz2>"
    return 1
  fi

  if [[ ! -f "$tarfile" ]]; then
    echo "File not found: $tarfile"
    return 1
  fi

  echo "Copying $tarfile to $tempdir"
  cp "$tarfile" "$tempdir"
  cd "$tempdir" || return 1

  # Extract based on file type
  case "$tarfile" in
    *.tar.gz)  tar -xzf "$(basename "$tarfile")" ;;
    *.tar.xz)  tar -xJf "$(basename "$tarfile")" ;;
    *.tar.zst) tar --use-compress-program=unzstd -xf "$(basename "$tarfile")" ;;
    *.tar.bz2) tar -xjf "$(basename "$tarfile")" ;;
    *) echo "Unsupported file type."; rm -rf "$tempdir"; return 1 ;;
  esac

  # Enter extracted directory
  cd */ || { echo "Could not enter extracted folder."; rm -rf "$tempdir"; return 1; }

  if [[ -f PKGBUILD ]]; then
    echo "Building and installing..."
    makepkg -si --noconfirm
    local result=$?
    echo "Cleaning up..."
    rm -rf "$tempdir"
    return $result
  else
    echo "No PKGBUILD found. Cannot build."
    rm -rf "$tempdir"
    return 1
  fi
}
flac(){
  read -p "Name of the song: " filename
  read -p "Enter the URL: " url
  yt-dlp -f bestaudio --extract-audio --audio-format flac --audio-quality 0 -o "~/Music/${filename}.flac" "$url"
}

#git aliases
alias gs="git status --short"
