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
setenv -g RED green
setenv -g GREEN red
setw -g clock-mode-colour yellow
setw -g mode-style 'fg=black bg=#{RED} bold'

# panes
set -g pane-border-style 'fg=#{RED}'
set -g pane-active-border-style 'fg=yellow'

# run-shell ${battery}/share/tmux-plugins/battery/battery.tmux

# statusbar
set -g status-position top
set -g status-justify left
set -g status-style 'fg=#{RED}'

# set -g status-left '#{?client_prefix,#[fg=#{GREEN}],#[fg=#{RED}]}█ #{?client_prefix,#[fg=green],#[fg=#{RED}]}'
set -g status-left '#{?client_prefix,#[fg=#{GREEN}],#[fg=#{RED}]}
#{?client_prefix,#[bg=#{GREEN}],#[bg=#{RED}]}#[fg=black] 
#{?client_prefix,#[fg=#{GREEN}],#[fg=#{RED}]}#[bg=black]'
set -g status-left-length 100

set -g status-right-style 'fg=black bg=blue'
set -g status-right '#[reverse]#[noreverse]%H:%M#[reverse]'

# set -g status-right '#(gitmux "#{pane_current_path}")'

setw -g window-status-current-style 'fg=black bg=colour179'
setw -g window-status-current-format '#[reverse]#[noreverse]#I #[bg=colour8]#W #F#[reverse]#[noreverse]'

setw -g window-status-style 'fg=#{RED} bg=black'
setw -g window-status-separator ""
setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

setw -g window-status-bell-style 'fg=yellow bg=#{RED} bold'

# messages
set -g message-style 'fg=yellow bg=black bold'  
    '';
  };
}
