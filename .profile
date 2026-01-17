#!/usr/bin/env bash

gc() {
    name="$1"
    email="$2"
    git config --global user.name "$1"
    git config --global user.email "$2"
}
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
