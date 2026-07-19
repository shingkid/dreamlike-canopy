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
STAGE_DIR=''
COMMIT_STARTED=false

cleanup() {
  [ -z "$STAGE_DIR" ] || rm -rf "$STAGE_DIR"
}

recover() {
  status=$?
  trap - EXIT HUP INT TERM
  cleanup
  if [ "$COMMIT_STARTED" = true ]; then
    if TARGET_HOME="$TARGET_HOME" "$SOURCE_DIR/scripts/rollback.sh" >/dev/null 2>&1; then
      printf '%s\n' "Install failed; restored backup: $BACKUP_DIR" >&2
    else
      printf '%s\n' "Install failed; recovery backup: $BACKUP_DIR" >&2
      printf '%s\n' "Run: TARGET_HOME=$TARGET_HOME $SOURCE_DIR/scripts/rollback.sh" >&2
    fi
  fi
  exit "$status"
}

backup_file() {
  source_file=$1
  label=$2
  mkdir -p "$BACKUP_DIR"
  if [ -e "$source_file" ]; then
    cp -p "$source_file" "$BACKUP_DIR/$label"
  else
    : > "$BACKUP_DIR/$label.absent"
  fi
}

stage_file() {
  source_file=$1
  staged_name=$2
  [ -r "$source_file" ] || { printf '%s\n' "Missing or unreadable package file: $source_file" >&2; exit 1; }
  cp "$source_file" "$STAGE_DIR/$staged_name"
}

install_file() {
  staged_name=$1
  destination=$2
  mkdir -p "$(dirname -- "$destination")"
  cp "$STAGE_DIR/$staged_name" "$destination"
}

mkdir -p "$CONFIG_DIR" "$GHOSTTY_DIR/themes"
STAGE_DIR=$(mktemp -d "$CONFIG_DIR/dreamlike-canopy-stage.XXXXXX")
trap recover EXIT HUP INT TERM
stage_file "$SOURCE_DIR/ghostty/config" ghostty-config
stage_file "$SOURCE_DIR/ghostty/themes/Dreamlike Canopy" dreamlike-canopy-theme
stage_file "$SOURCE_DIR/ghostty/themes/Dreamlike Glade" dreamlike-glade-theme
stage_file "$SOURCE_DIR/starship/starship.toml" starship.toml

COMMIT_STARTED=true
backup_file "$GHOSTTY_DIR/config" ghostty-config
backup_file "$GHOSTTY_DIR/themes/Dreamlike Canopy" dreamlike-canopy-theme
backup_file "$GHOSTTY_DIR/themes/Dreamlike Glade" dreamlike-glade-theme
backup_file "$STARSHIP_FILE" starship.toml
install_file ghostty-config "$GHOSTTY_DIR/config"
install_file dreamlike-canopy-theme "$GHOSTTY_DIR/themes/Dreamlike Canopy"
install_file dreamlike-glade-theme "$GHOSTTY_DIR/themes/Dreamlike Glade"
install_file starship.toml "$STARSHIP_FILE"
COMMIT_STARTED=false
cleanup
trap - EXIT HUP INT TERM

printf '%s\n' "Installed Dreamlike Canopy and Dreamlike Glade. Backup: $BACKUP_DIR"
printf '%s\n' "Restart Ghostty, then start a new shell to see the prompt."
