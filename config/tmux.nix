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
setenv -g Rosewater '#f5e0dc'
setenv -g Flamingo '#f2cdcd'
setenv -g Pink '#f5c2e7'
setenv -g Mauve '#cba6f7'
setenv -g Red '#f38ba8'
setenv -g Maroon '#eba0ac'
setenv -g Peach '#fab387'
setenv -g Yellow '#f9e2af'
setenv -g Green '#a6e3a1'
setenv -g Teal '#94e2d5'
setenv -g Sky '#89dceb'
setenv -g Sapphire '#74c7ec'
setenv -g Blue '#89b4fa'
setenv -g Lavender '#b4befe'
setenv -g Text '#cdd6f4'
setenv -g Subtext1 '#bac2de'
setenv -g Subtext0 '#a6adc8'
setenv -g Overlay2 '#9399b2'
setenv -g Overlay1 '#7f849c'
setenv -g Overlay0 '#6c7086'
setenv -g Surface2 '#585b70'
setenv -g Surface1 '#45475a'
setenv -g Surface0 '#313244'
setenv -g Base '#1e1e2e'
setenv -g Mantle '#181825'
setenv -g Crust '#11111b'

# setw -g clock-mode-colour #{Yellow}
setw -g mode-style 'fg=black bg=#{Red} bold'

# panes
set -g pane-border-style 'fg=#{Red}'
set -g pane-active-border-style 'fg=#{Blue}'

# run-shell ${battery}/share/tmux-plugins/battery/battery.tmux

# statusbar
set -g status-position top
set -g status-justify left
set -g status-style 'fg=#{Red}'

set -g status-left '#{?client_prefix,#[fg=#{Red}],#[fg=#{Green}]}
#{?client_prefix,#[bg=#{Red}],#[bg=#{Green}]}#[fg=black] #S
#{?client_prefix,#[fg=#{Red}],#[fg=#{Green}]}#[bg=black]   '
set -g status-left-length 100

set -g status-right-style 'fg=black bg=blue'
set -g status-right '#[reverse]#[noreverse]%H:%M#[reverse]'

# set -g status-right "#[align=absolute-centre] Hello, world! #[align=right]"
# set -ga status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\ 📅 %d.%m.%y 🕰  %H:%M 💻 #{client_user}@#H "
# set -g status-right-length 65


# set -g status-right '#(gitmux "#{pane_current_path}")'

# setw -g window-status-current-style 'fg=#{Text} bg=#{Peach}'
# setw -g window-status-style 'fg=#{Text} bg=#{Mauve}'

setw -g window-status-separator ' '

setw -g window-status-current-format '#[bg=black fg=#{Peach}]#[fg=#{Text} bg=#{Peach}]#I #[bg=#{Surface0}] #W #F#[bg=black fg=#{Surface0}]'
setw -g window-status-format '#[bg=black fg=#{Overlay2}]#[fg=#{Text} bg=#{Overlay2}]#I #[bg=#{Surface2}] #W #F#[bg=black fg=#{Surface2}]'

setw -g window-status-bell-style 'fg=#{Yellow} bg=#{Red} bold'

# messages
set -g message-style 'fg=#{Yellow} bg=black bold'  
    '';
  };
}
