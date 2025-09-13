FROM docker.io/archlinux:latest

# Update keyring first to avoid signature issues
RUN pacman -Sy --noconfirm archlinux-keyring

# System update
RUN pacman -Syyu --noconfirm

# Install your packages
RUN pacman -S --noconfirm --needed \
    git neovim python nodejs npm unzip gcc cmake make base-devel glibc binutils fakeroot
RUN pacman -S --noconfirm tldr lsd zsh fzf eza zoxide zellij
RUN curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin

RUN pacman -S sudo --noconfirm

# Clean package cache to reduce image size
RUN pacman -Scc --noconfirm

# Create user
RUN useradd -m -s /bin/bash tysufa && \
    echo "tysufa ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER tysufa
WORKDIR /home/tysufa

# Copy your existing config
# COPY --chown=tysufa:tysufa ./nvim /home/tysufa/.config/nvim

RUN git clone https://github.com/tysufa/tysufaOs.git

RUN mkdir ~/.config
RUN ln -s ~/tysufaOs/wsl/nvim ~/.config/
RUN ln -s ~/tysufaOs/wsl/zshrc ~/.zshrc
RUN ln -s ~/tysufaOs/wsl/ohmyposh/ ~/.config/oh-my-posh
RUN ln -s ~/tysufaOs/wsl/zellij/ ~/.config/ && echo "delete cache"

# install lsps
# RUN git clone https://github.com/williamboman/mason.nvim ~/.config/nvim/lua/mason && \
#     nvim --headless -c 'MasonInstall pyright clangd' -c 'quitall'

# Install Lazy.nvim and plugins
# RUN git clone --filter=blob:none --branch=stable \
#     https://github.com/folke/lazy.nvim.git \
#     ~/.local/share/nvim/lazy/lazy.nvim && \
#     nvim --headless -c 'quitall'  # Triggers plugin install

VOLUME ["/home/tysufa/.local/"]

CMD ["/bin/zsh"]
