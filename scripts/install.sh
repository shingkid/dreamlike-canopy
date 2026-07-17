#!/bin/sh
# Install the package while preserving any current user configuration.
set -eu

SOURCE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TARGET_HOME=${TARGET_HOME:-"$HOME"}
CONFIG_DIR="$TARGET_HOME/.config"
GHOSTTY_DIR="$CONFIG_DIR/ghostty"
STARSHIP_FILE="$CONFIG_DIR/starship.toml"
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$CONFIG_DIR/dreamlike-canopy-backups/$STAMP"

backup_file() {
  source_file=$1
  label=$2
  if [ -e "$source_file" ]; then
    mkdir -p "$BACKUP_DIR"
    cp -p "$source_file" "$BACKUP_DIR/$label"
  else
    mkdir -p "$BACKUP_DIR"
    : > "$BACKUP_DIR/$label.absent"
  fi
}

backup_file "$GHOSTTY_DIR/config" ghostty-config
backup_file "$GHOSTTY_DIR/themes/Dreamlike Canopy" dreamlike-canopy-theme
backup_file "$GHOSTTY_DIR/themes/Dreamlike Glade" dreamlike-glade-theme
backup_file "$STARSHIP_FILE" starship.toml

mkdir -p "$GHOSTTY_DIR/themes"
cp "$SOURCE_DIR/ghostty/config" "$GHOSTTY_DIR/config"
cp "$SOURCE_DIR/ghostty/themes/Dreamlike Canopy" "$GHOSTTY_DIR/themes/Dreamlike Canopy"
cp "$SOURCE_DIR/ghostty/themes/Dreamlike Glade" "$GHOSTTY_DIR/themes/Dreamlike Glade"
cp "$SOURCE_DIR/starship/starship.toml" "$STARSHIP_FILE"

printf '%s\n' "Installed Dreamlike Canopy and Dreamlike Glade. Backup: $BACKUP_DIR"
printf '%s\n' "Restart Ghostty, then start a new shell to see the prompt."
