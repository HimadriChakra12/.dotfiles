#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  Bash autocomplete enhancements
#  1. Up/Down arrow  →  history search filtered by current input
#  2. Tab            →  fzf picker when multiple candidates exist
#
#  Requirements: fzf  (apt install fzf  /  brew install fzf)
#  Source from ~/.bashrc:
#    source /path/to/bash_autocomplete.sh
# ─────────────────────────────────────────────────────────────


# ── 1. UP / DOWN ARROW  →  prefix-filtered history ───────────
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"


# ── 2. TAB  →  fzf picker ────────────────────────────────────
#
#  Uses bind -x to intercept Tab at readline level — this is
#  the only reliable way in bash (complete -D gets overridden).

_fzf_tab_complete() {
    local cur="${READLINE_LINE}"
    local point="${READLINE_POINT}"

    # Find the start of the current word
    local before="${cur:0:$point}"
    local word="${before##* }"          # last space-delimited token
    local prefix="${before:0:$((point - ${#word}))}"
    local after="${cur:$point}"

    # Choose completion source based on position
    local candidates
    if [[ -z "$prefix" || "$prefix" =~ ^[[:space:]]+$ ]]; then
        # First word → commands, aliases, functions
        candidates=$(compgen -A function -A alias -A builtin -A command -- "$word" 2>/dev/null | sort -u)
    else
        # Argument → files and directories
        candidates=$(compgen -f -- "$word" 2>/dev/null | sort -u)
    fi

    local lines
    lines=$(printf '%s\n' $candidates | grep -c .)

    if [[ $lines -eq 0 ]]; then
        echo -en "\a"   # bell — nothing found
        return

    elif [[ $lines -eq 1 ]]; then
        # Single match — complete inline
        local match="$candidates"
        [[ -d "$match" ]] && match="${match%/}/" || match="${match} "
        READLINE_LINE="${prefix}${match}${after}"
        READLINE_POINT=$(( ${#prefix} + ${#match} ))

    else
        # Multiple matches — fzf picker
        local chosen
        chosen=$(printf '%s\n' $candidates \
            | fzf \
                --height=40% \
                --layout=reverse \
                --border=rounded \
                --prompt=" ❯ " \
                --info=inline \
                --bind "tab:down,shift-tab:up" \
                --query="$word" \
                --select-1 \
                --exit-0 \
            2>/dev/tty)

        if [[ -n "$chosen" ]]; then
            [[ -d "$chosen" ]] && chosen="${chosen%/}/" || chosen="${chosen} "
            READLINE_LINE="${prefix}${chosen}${after}"
            READLINE_POINT=$(( ${#prefix} + ${#chosen} ))
        fi
    fi
}

# Hook Tab to our function at readline level
bind -x '"\t": _fzf_tab_complete'
