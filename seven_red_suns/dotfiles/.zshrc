# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


# used for podman
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
  export XDG_RUNTIME_DIR=/run/user/$UID
  if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR=/tmp/$USER-runtime
    if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
      mkdir -m 0700 "$XDG_RUNTIME_DIR"
    fi
  fi
fi

# enables osc 133 for kitty terminals
if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# zinit wait lucid for \
#     atload"zicompinit; zicdreplay" \
#     zsh-users/zsh-completions \
#     zsh-users/zsh-autosuggestions
#
# zinit wait lucid for \
#     Aloxaf/fzf-tab
#
# zinit wait lucid for \
#     zsh-users/zsh-syntax-highlighting
#
# zinit wait"0a" lucid depth"1" for \
#     jeffreytse/zsh-vi-mode

# Add in zsh plugins
zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice depth=1

export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# Add in snippets
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit -C

#open buffer line in editor
# autoload -Uz edit-command-line
# zle -N edit-command-line
# bindkey '^x^e' edit-command-line

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^k' history-search-backward
bindkey '^n' history-search-forward
bindkey '^j' history-search-forward
bindkey ' ' magic-space



# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'


# Alias
alias cat="bat"
alias ls="eza --icons=auto"
alias lss="eza -l --no-permissions --no-filesize --no-user --no-time --icons"
alias ll="eza -lh --icons=auto --grid --group-directories-first"
alias lk="command ls -l --color=auto"
alias la="eza -lah --icons=auto --grid --group-directories-first"
alias h="cd /home/tysufa"
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias checkout="git log --oneline | gum filter | cut -d' ' -f1 | xargs git switch --detach"
alias commit="~/scripts/commit.sh"

bindkey -s '^Xm' 'git commit -m ""\C-b'
bindkey -s '^Xc' '\C-a echo "\C-e\" | wl-copy'

EDITOR=nvim
ZVM_VI_EDITOR=nvim

# Start ssh-agent if not running
# if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l &>/dev/null; then
#     eval "$(ssh-agent -s)"
# fi

# for some reason, this variable is set which break pass, so we remove it to use xclip instead of wl-copy
# unset WAYLAND_DISPLAY

alias gp="ssh-add -l | grep philemon.penot@gmail.com >/dev/null || ssh-add ~/.ssh/id_ed25519 && git push"
alias gt="pass -c programmation/github"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias ".."="cd .."
alias "..."="cd ../.."

alias c='clear'

alias -g DN='2>/dev/null'
alias -g C='| wl-copy'

zellij() {
  # If arguments are passed (e.g., zellij -h), run standard zellij
  if [ $# -gt 0 ]; then
    command zellij "$@"
    return
  fi

  local raw_choice session_name new_name

  # Prepend "+ New Session" to zellij ls using process substitution
  raw_choice=$(gum filter --no-strip-ansi < <(echo "+ New Session"; command zellij ls))

  # Return early if selection was cancelled (Esc / Ctrl+C)
  if [[ -z "$raw_choice" ]]; then
    return
  fi

  # Check if user selected the "+ New Session" option
  if [[ "$raw_choice" == "+ New Session"* ]]; then
    new_name=$(gum input --placeholder "Enter new session name...")
    if [[ -n "$new_name" ]]; then
      command zellij -s "$new_name"
    else
      command zellij
    fi
    return
  fi

  # Otherwise, clean ANSI color codes and extract the selected session name
  session_name=$(echo "$raw_choice" | awk '{print $1}')

  if [[ -n "$session_name" ]]; then
    command zellij attach "$session_name"
  fi
}

export PATH="/home/tysufa/.local/bin:$PATH"
export PATH="/home/tysufa/.cargo/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Shell integrations
eval "$(oh-my-posh init zsh --config ~/tysufaOs/moon/ohmyposh/zen.toml)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"


# ---------- Per-session history for Zellij ----------------
if [[ -n "$ZELLIJ_SESSION_NAME" ]]; then
    # Create the directory if it doesn't exist
    mkdir -p "$HOME/.zsh_history_zellij"
    # Set history file to be specific to the session name
    HISTFILE="$HOME/.zsh_history_zellij/$ZELLIJ_SESSION_NAME"
fi


# ---------- LUSTRE V4 ------------
# export PATH="$PATH:/usr/share/lustre-tools-4/bin"
# export LUSTRE_INSTALL="/usr/share/lustre-tools-4"
# export _POSIX2_VERSION=199209

# good fastfetch presets : 31, 28, 17, 6 fastfetch -c examples/17
fastfetch
