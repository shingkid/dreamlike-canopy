#!/bin/sh
# Restore the most recent backup made by install.sh.
set -eu

TARGET_HOME=${TARGET_HOME:-"$HOME"}
CONFIG_DIR="$TARGET_HOME/.config"
GHOSTTY_DIR="$CONFIG_DIR/ghostty"
STARSHIP_FILE="$CONFIG_DIR/starship.toml"
COMPACT_STARSHIP_FILE="$CONFIG_DIR/dreamlike-canopy/starship-compact.toml"
BACKUP_ROOT="$CONFIG_DIR/dreamlike-canopy-backups"

if [ ! -d "$BACKUP_ROOT" ]; then
  printf '%s\n' "No Dreamlike Canopy backup directory was found." >&2
  exit 1
fi

BACKUP_DIR=$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d -print | sort | tail -n 1)
if [ -z "$BACKUP_DIR" ]; then
  printf '%s\n' "No Dreamlike Canopy backup was found." >&2
  exit 1
fi

restore_file() {
  backup_name=$1
  destination=$2
  if [ -e "$BACKUP_DIR/$backup_name" ]; then
    mkdir -p "$(dirname -- "$destination")"
    cp -p "$BACKUP_DIR/$backup_name" "$destination"
  elif [ -e "$BACKUP_DIR/$backup_name.absent" ]; then
    rm -f "$destination"
  fi
}

restore_file ghostty-config "$GHOSTTY_DIR/config"
restore_file dreamlike-canopy-theme "$GHOSTTY_DIR/themes/Dreamlike Canopy"
restore_file dreamlike-glade-theme "$GHOSTTY_DIR/themes/Dreamlike Glade"
restore_file starship.toml "$STARSHIP_FILE"
restore_file starship-compact.toml "$COMPACT_STARSHIP_FILE"

printf '%s\n' "Restored backup: $BACKUP_DIR"
printf '%s\n' "Restart Ghostty, then start a new shell."
