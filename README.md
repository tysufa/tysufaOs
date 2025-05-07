# Dotfiles Repository

![Dotfiles](https://img.shields.io/badge/-Dotfiles-lightgrey?style=flat-square) 
![Configuration](https://img.shields.io/badge/-Configuration-blue?style=flat-square)

My personal configuration files for Unix-like systems. These help me maintain a consistent development environment across machines.

## 📁 Contents
- a wsl folder with my dotfiles for debian based wsl
- a docker folder to try to replicate my wsl setup on any machine (the dev environment is on arch)
- the rest are for my nixos systems


## 🚀 Installation

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tysufa/tysufaOs.git ~/tysufaOs
   ```
2. If you are on a nixos system :
   ```bash
   cd tysufaOs && sudo nixos-rebuild switch --flake .
   nh home switch
   nh os switch
   ```
3. If you are on a debian based system you can link the dotfiles in the wsl folder, you will need to install the programs yourself
4. Otherwise you can use the docker container :
   ```bash
   cd tysufaOs/docker/tysufaOs
   podman build -t tysufaos .
   ./run.sh
   ```

## 🔧 Features
- Shell: custom prompt with [ohmyposh](https://ohmyposh.dev/), zsh
- Neovim: Dev environment for c++ (debugger missing for now)
- Zellij: Session management and theming
