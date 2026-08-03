DOT     := $(shell pwd)
HOMEDIR ?= $(shell getent passwd $$(logname 2>/dev/null || echo $$SUDO_USER) | cut -d: -f6)
CONF    := $(HOMEDIR)/.config

CONF_LINKS := GIMP btop darktable dunst fastfetch flameshot gh git i3 lazygit \
              mpv paru pcmanfm pikaur qimgv rofi mustat Wallpaper sxwm-conf \
              wezterm sxbarc sxwmrc alacritty.toml starship.toml \
              greenclip.toml libinput-gestures.conf

OKULAR_LINKS := okularrc okularpartrc

HOME_LINKS := bashconf .profile .bashrc .zshrc .tmux.conf .vimrc

.PHONY: $(CONF_LINKS) $(OKULAR_LINKS) $(HOME_LINKS)

$(CONF_LINKS):
	ln -sfn "$(DOT)/$@" "$(CONF)/$@"

$(OKULAR_LINKS):
	ln -sfn "$(DOT)/Okular/$@" "$(CONF)/$@"

$(HOME_LINKS):
	ln -sfn "$(DOT)/$@" "$(HOMEDIR)/$@"
