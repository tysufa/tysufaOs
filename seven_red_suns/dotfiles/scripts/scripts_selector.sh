#!/usr/bin/env bash

# Define the script names and their corresponding actions

choice=$(gum filter "Update" "Garbage collect" "Exit" --placeholder "Select an action")

case "$choice" in
  "Update")
      sudo nixos-rebuild switch --flake ~/tysufaOs#seven_red_suns
      ;;
  "Garbage collect")
      nix-collect-garbage --delete-older-than 7d
      ;;
  "Exit"|*)
      exit 0
      ;;
esac
