FROM docker.io/archlinux:latest

# Install dependencies (same as above)
RUN pacman -Syu --noconfirm --needed git neovim python nodejs npm unzip gcc

# Create user
RUN useradd -m -s /bin/bash tysufa

USER tysufa
WORKDIR /home/tysufa

# Copy your existing config
COPY --chown=tysufa:tysufa ./nvim /home/tysufa/.config/nvim

# install lsps
# RUN git clone https://github.com/williamboman/mason.nvim ~/.config/nvim/lua/mason && \
#     nvim --headless -c 'MasonInstall pyright clangd' -c 'quitall'

# Install Lazy.nvim and plugins
# RUN git clone --filter=blob:none --branch=stable \
#     https://github.com/folke/lazy.nvim.git \
#     ~/.local/share/nvim/lazy/lazy.nvim && \
#     nvim --headless -c 'quitall'  # Triggers plugin install

VOLUME ["/home/tysufa/.local/"]

CMD ["/bin/bash"]
