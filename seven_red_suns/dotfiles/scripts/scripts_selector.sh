#!/usr/bin/env bash

# Define the script names and their corresponding actions

choice=$(gum filter "Update" "Garbage collect" "Backup" "Exit" --placeholder "Select an action")

case "$choice" in
  "Update")
      sudo nixos-rebuild switch --flake ~/tysufaOs/seven_red_suns#seven_red_suns --impure
      ;;
  "Garbage collect")
      sudo nix-collect-garbage --delete-older-than 7d
      ;;
  "Backup")
      restic --repo ~/Backup/restic backup ~/.config/zen ~/vimwiki/
      restic -r sftp:tysufa@192.168.1.238:/mnt/storage/Backups/restic copy --from-repo ~/Backup/restic
      ;;
  "Exit"|*)
      exit 0
      ;;
esac
