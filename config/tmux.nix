{ pkgs, ... }:
{
  stylix.targets.tmux.enable = false; 
  programs.tmux = {
    mouse = true;
    enable = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    shortcut = "Space";
    terminal = "tmux-256color";
    # plugins = with pkgs.tmuxPlugins;[ catppuccin battery ];

  extraConfig = with pkgs.tmuxPlugins;''
# split panes using | and -, make sure they open in the same path
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# unbind '"'
# unbind %

# open new windows in the current path
bind c new-window -c "#{pane_current_path}"

unbind p
bind p previous-window

bind-key r run-shell 'nh home switch && tmux source ~/.config/tmux/tmux.conf && tmux display-message reloaded'

# shorten command delay
set -sg escape-time 1

# don't rename windows automatically after a command
# set -g allow-rename off

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-j select-pane -L
bind -n M-l select-pane -R
bind -n M-u select-pane -U
bind -n M-d select-pane -D

# present a menu of URLs to open from the visible pane. sweet.
bind u capture-pane \;\
    save-buffer /tmp/tmux-buffer \;\
    split-window -l 10 "urlview /tmp/tmux-buffer"


# Design Tweaks
# -------------

#  modes
setenv -g COULEUR yellow
setw -g clock-mode-colour yellow
setw -g mode-style 'fg=black bg=red bold'

# panes
set -g pane-border-style 'fg=red'
set -g pane-active-border-style 'fg=yellow'

run-shell ${battery}/share/tmux-plugins/battery/battery.tmux

# statusbar
set -g status-position top
set -g status-justify left
set -g status-style 'fg=red'

# set -g status-left '#{?client_prefix,#[fg=green],#[fg=red]}█'
set -g status-left '#[fg=red]#[bg=red,fg=black] #[fg=red,bg=black]#[noreverse]'
set -g status-left-length 100

set -g status-right-style 'fg=black bg=blue'
set -g status-right '#[reverse]#[noreverse]%H:%M#[reverse]'

# set -g status-right '#(gitmux "#{pane_current_path}")'

setw -g window-status-current-style 'fg=black bg=red'
setw -g window-status-current-format '#[reverse]#[noreverse]#I #W #F#[reverse]#[noreverse]'

setw -g window-status-style 'fg=red bg=black'
setw -g window-status-separator ""
setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

setw -g window-status-bell-style 'fg=yellow bg=red bold'

# messages
set -g message-style 'fg=yellow bg=black bold'  

set -g status-right '#{battery_status_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M '
    '';
  };
}
