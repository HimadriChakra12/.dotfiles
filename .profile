#!/usr/bin/env bash
APP=$HOME/.local/share/applications
export PATH="$HOME/sayarchi/scripts:$PATH"
export PATH="$HOME/sayarchi/bin:$PATH"
export PATH="$HOME/.dotfiles:$PATH"
export PATH="$HOME/Music:$PATH"

mountit(){
    name="$1"
    mount="$2"
    mkdir -p "/mnt/$2"
    sudo mount -o loop,ro "$1" "/mnt/$2"
}
reg(){
    url="$1"
    if [ -z "$url" ]; then
        echo "Usage: $0 <url>"
        exit 1
    fi

    # Escape regex special characters
    escaped=$(printf '%s' "$url" | sed -e 's/[.[\*^$()+?{|]/\\&/g' -e 's/\\/\\\\/g')

    # Output anchored regex
    echo "^${escaped}\$"
}
mkcd(){
    location="$1"
    if [ -z "$location" ]; then
        echo "Usage: $0 <url>"
        exit 1
    fi
    mkdir $location && cd $location
    # Output anchored regex
    pwd
}
replace-word() {
  find . -type d -name .git -prune -o -type f -exec sed -i "s/$1/$2/g" {} +
}
alias cmus='cmus-init'

fs() {
    ls | grep "$@"
}
