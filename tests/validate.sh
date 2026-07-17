#!/bin/sh
set -eu

PACKAGE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
STARSHIP_CONFIG_FILE="$PACKAGE_DIR/starship/starship.toml"
GHOSTTY_CONFIG_FILE="$PACKAGE_DIR/ghostty/config"
GHOSTTY_THEME_FILE="$PACKAGE_DIR/ghostty/themes/Dreamlike Canopy"
GHOSTTY_LIGHT_THEME_FILE="$PACKAGE_DIR/ghostty/themes/Dreamlike Glade"

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  file=$1
  expected=$2
  grep -F "$expected" "$file" >/dev/null || fail "$file does not contain: $expected"
}

assert_not_contains() {
  file=$1
  unexpected=$2
  if grep -F "$unexpected" "$file" >/dev/null; then
    fail "$file unexpectedly contains: $unexpected"
  fi
}

assert_same() {
  expected=$1
  actual=$2
  cmp -s "$expected" "$actual" || fail "$actual differs from $expected"
}

validate_starship() {
  command -v starship >/dev/null 2>&1 || fail "starship is required for validation"
  STARSHIP_CONFIG="$STARSHIP_CONFIG_FILE" starship print-config >/dev/null

  assert_contains "$STARSHIP_CONFIG_FILE" 'format = "[](fg:capsule)'
  assert_contains "$STARSHIP_CONFIG_FILE" '[](fg:capsule)  "'
  assert_contains "$STARSHIP_CONFIG_FILE" 'truncation_length = 0'
  assert_contains "$STARSHIP_CONFIG_FILE" 'truncate_to_repo = false'
  assert_contains "$STARSHIP_CONFIG_FILE" 'right_format = "$time"'
  assert_contains "$STARSHIP_CONFIG_FILE" 'success_symbol = "[❯](fg:mint)"'
  assert_contains "$STARSHIP_CONFIG_FILE" 'capsule = "bright-black"'
  assert_contains "$STARSHIP_CONFIG_FILE" 'capsule_text = "bright-white"'
  assert_contains "$STARSHIP_CONFIG_FILE" '[$conflicted](fg:coral)'
  assert_contains "$STARSHIP_CONFIG_FILE" '[$deleted](fg:coral)'
  assert_contains "$STARSHIP_CONFIG_FILE" '[$modified](fg:sunlight)'
  assert_contains "$STARSHIP_CONFIG_FILE" '[$staged](fg:canopy)'

  rendered=$(STARSHIP_CONFIG="$STARSHIP_CONFIG_FILE" starship module directory \
    --path "$PACKAGE_DIR/starship" \
    --logical-path "$PACKAGE_DIR/starship")
  case "$rendered" in
    *""*""*) ;;
    *) fail "rendered directory module is missing rounded Powerline caps" ;;
  esac

  expected_path="$PACKAGE_DIR/starship"
  case "$expected_path" in
    "$HOME"/*) expected_path="~/${expected_path#"$HOME"/}" ;;
  esac
  case "$rendered" in
    *"$expected_path"*) ;;
    *) fail "rendered directory module does not show the full path" ;;
  esac
  case "$rendered" in
    *"…/"*) fail "rendered directory module still truncates the path" ;;
  esac

  divergence_root=$(mktemp -d "${TMPDIR:-/tmp}/dreamlike-canopy-divergence.XXXXXX")
  remote="$divergence_root/remote.git"
  local_repo="$divergence_root/local"
  peer_repo="$divergence_root/peer"
  git init --bare -q "$remote"
  git init -q -b main "$local_repo"
  git -C "$local_repo" config user.email test@example.com
  git -C "$local_repo" config user.name test
  printf '%s\n' base > "$local_repo/status.txt"
  git -C "$local_repo" add status.txt
  git -C "$local_repo" commit -qm base
  git -C "$local_repo" remote add origin "$remote"
  git -C "$local_repo" push -qu origin main
  git -C "$local_repo" branch --set-upstream-to=origin/main main >/dev/null
  git clone -q "$remote" "$peer_repo"
  git -C "$peer_repo" config user.email test@example.com
  git -C "$peer_repo" config user.name test
  printf '%s\n' remote >> "$peer_repo/status.txt"
  git -C "$peer_repo" commit -am remote -q
  git -C "$peer_repo" push -q
  printf '%s\n' local >> "$local_repo/status.txt"
  git -C "$local_repo" commit -am local -q
  git -C "$local_repo" fetch -q origin
  divergence_rendered=$(STARSHIP_CONFIG="$STARSHIP_CONFIG_FILE" starship module git_status --path "$local_repo")
  rm -rf "$divergence_root"
  case "$divergence_rendered" in
    *"⇕⇡1⇣1"*) ;;
    *) fail "rendered diverged Git status is missing ⇕⇡1⇣1" ;;
  esac
}

validate_ghostty_static() {
  known_config_keys='theme font-family font-size background-opacity background-blur window-padding-x window-padding-y cursor-style cursor-style-blink shell-integration'
  known_theme_keys='background foreground cursor-color cursor-text selection-background selection-foreground palette background-opacity minimum-contrast'

  assert_not_contains "$GHOSTTY_CONFIG_FILE" 'background-opacity ='
  assert_contains "$GHOSTTY_CONFIG_FILE" 'theme = light:Dreamlike Glade,dark:Dreamlike Canopy'
  assert_contains "$GHOSTTY_THEME_FILE" 'background-opacity = 0.86'
  assert_contains "$GHOSTTY_THEME_FILE" 'minimum-contrast = 4.5'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'background-opacity = 0.78'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'minimum-contrast = 4.5'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'background = #E7F0E8'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'foreground = #1F4249'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'cursor-color = #2D8D6C'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'selection-background = #D8D0E2'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 5=#624781'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 7=#506864'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 8=#D5CDE3'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 10=#1F6B4E'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 11=#805815'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 12=#345F97'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 13=#73549D'
  assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'palette = 14=#1F686C'
  assert_contains "$PACKAGE_DIR/README.md" '## Git status symbols'
  assert_contains "$PACKAGE_DIR/README.md" '## Troubleshooting missing glyphs'

  while IFS='=' read -r raw_key raw_value; do
    key=$(printf '%s' "$raw_key" | tr -d '[:space:]')
    value=$(printf '%s' "$raw_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    case "$key" in ''|'#'*) continue ;; esac
    case " $known_config_keys " in *" $key "*) ;; *) fail "unknown Ghostty config key: $key" ;; esac
    [ -n "$value" ] || fail "empty Ghostty config value for $key"
  done < "$GHOSTTY_CONFIG_FILE"

  validate_theme_file() {
    theme_file=$1
    palette_count=0
    [ -f "$theme_file" ] || fail "missing Ghostty theme: $theme_file"
    while IFS='=' read -r raw_key raw_value; do
      key=$(printf '%s' "$raw_key" | tr -d '[:space:]')
      value=$(printf '%s' "$raw_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      case "$key" in ''|'#'*) continue ;; esac
      case " $known_theme_keys " in *" $key "*) ;; *) fail "unknown Ghostty theme key: $key" ;; esac
      [ -n "$value" ] || fail "empty Ghostty theme value for $key"
      case "$key" in
        palette)
          palette_count=$((palette_count + 1))
          printf '%s\n' "$value" | grep -E '^(0|[1-9]|1[0-5])=#[0-9A-Fa-f]{6}$' >/dev/null || fail "invalid Ghostty palette entry: $value"
          ;;
        background-opacity)
          printf '%s\n' "$value" | grep -E '^0\.[0-9]+$|^1(\.0+)?$' >/dev/null || fail "invalid Ghostty background opacity: $value"
          ;;
        minimum-contrast)
          printf '%s\n' "$value" | grep -E '^([1-9]|1[0-9]|2[01])(\.[0-9]+)?$' >/dev/null || fail "invalid Ghostty minimum contrast: $value"
          ;;
        *)
          printf '%s\n' "$value" | grep -E '^#[0-9A-Fa-f]{6}$' >/dev/null || fail "invalid Ghostty color for $key: $value"
          ;;
      esac
    done < "$theme_file"
    [ "$palette_count" -eq 16 ] || fail "$theme_file must define exactly 16 ANSI palette entries"
  }

  validate_theme_file "$GHOSTTY_THEME_FILE"
  validate_theme_file "$GHOSTTY_LIGHT_THEME_FILE"

  ghostty_bin=''
  if command -v ghostty >/dev/null 2>&1; then
    ghostty_bin=$(command -v ghostty)
  elif [ -x /Applications/Ghostty.app/Contents/MacOS/ghostty ]; then
    ghostty_bin=/Applications/Ghostty.app/Contents/MacOS/ghostty
  fi

  if [ -n "$ghostty_bin" ]; then
    XDG_CONFIG_HOME="$PACKAGE_DIR" "$ghostty_bin" +validate-config --config-file="$GHOSTTY_CONFIG_FILE"
    "$ghostty_bin" +validate-config --config-file="$GHOSTTY_THEME_FILE"
    "$ghostty_bin" +validate-config --config-file="$GHOSTTY_LIGHT_THEME_FILE"
  fi
}

exercise_install_and_rollback() {
  test_root=$(mktemp -d "${TMPDIR:-/tmp}/dreamlike-canopy-test.XXXXXX")
  trap 'rm -rf "$test_root"' EXIT HUP INT TERM

  existing_home="$test_root/existing-home"
  mkdir -p "$existing_home/.config/ghostty/themes"
  printf '%s\n' 'old ghostty config' > "$existing_home/.config/ghostty/config"
  printf '%s\n' 'old theme' > "$existing_home/.config/ghostty/themes/Dreamlike Canopy"
  printf '%s\n' 'old light theme' > "$existing_home/.config/ghostty/themes/Dreamlike Glade"
  printf '%s\n' 'old starship config' > "$existing_home/.config/starship.toml"

  TARGET_HOME="$existing_home" "$PACKAGE_DIR/scripts/install.sh" >/dev/null
  assert_same "$GHOSTTY_CONFIG_FILE" "$existing_home/.config/ghostty/config"
  assert_same "$GHOSTTY_THEME_FILE" "$existing_home/.config/ghostty/themes/Dreamlike Canopy"
  assert_same "$GHOSTTY_LIGHT_THEME_FILE" "$existing_home/.config/ghostty/themes/Dreamlike Glade"
  assert_same "$STARSHIP_CONFIG_FILE" "$existing_home/.config/starship.toml"

  TARGET_HOME="$existing_home" "$PACKAGE_DIR/scripts/rollback.sh" >/dev/null
  [ "$(cat "$existing_home/.config/ghostty/config")" = 'old ghostty config' ] || fail "Ghostty config was not restored"
  [ "$(cat "$existing_home/.config/ghostty/themes/Dreamlike Canopy")" = 'old theme' ] || fail "Ghostty theme was not restored"
  [ "$(cat "$existing_home/.config/ghostty/themes/Dreamlike Glade")" = 'old light theme' ] || fail "Ghostty light theme was not restored"
  [ "$(cat "$existing_home/.config/starship.toml")" = 'old starship config' ] || fail "Starship config was not restored"

  empty_home="$test_root/empty-home"
  mkdir -p "$empty_home"
  TARGET_HOME="$empty_home" "$PACKAGE_DIR/scripts/install.sh" >/dev/null
  TARGET_HOME="$empty_home" "$PACKAGE_DIR/scripts/rollback.sh" >/dev/null
  [ ! -e "$empty_home/.config/ghostty/config" ] || fail "rollback did not remove newly installed Ghostty config"
  [ ! -e "$empty_home/.config/ghostty/themes/Dreamlike Canopy" ] || fail "rollback did not remove newly installed theme"
  [ ! -e "$empty_home/.config/ghostty/themes/Dreamlike Glade" ] || fail "rollback did not remove newly installed light theme"
  [ ! -e "$empty_home/.config/starship.toml" ] || fail "rollback did not remove newly installed Starship config"

  rm -rf "$test_root"
  trap - EXIT HUP INT TERM
}

sh -n "$PACKAGE_DIR/scripts/install.sh"
sh -n "$PACKAGE_DIR/scripts/rollback.sh"
validate_starship
validate_ghostty_static
exercise_install_and_rollback

printf '%s\n' "All configuration and installer checks passed."
