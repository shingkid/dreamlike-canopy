# Dreamlike Canopy — Ghostty + Starship + Codex + Pi

This package pairs dark Dreamlike Canopy with its light Dreamlike Glade
companion and the Design A Starship prompt. Dreamlike Glade uses forest teal,
leaf green, sky blue, and wisteria sampled from Hiroo Isono forest paintings,
with a lavender-glass directory capsule and selection. The colors are lifted
and adjusted for a readable light terminal. Ghostty follows the
current macOS Appearance automatically. Starship uses the themes' ANSI colors,
so its rounded directory capsule, Git context, status, runtimes, and prompt
character adapt at the same time without a separate light-mode configuration.

The package also includes matching Codex app themes. Dreamlike Glade carries
the light chrome with Proof syntax highlighting; Dreamlike Canopy carries the
dark chrome with Everforest syntax highlighting. Both use Codex's native theme
share format, preserve the forest palette's semantic diff colors, and follow
the app's system appearance setting as a pair.

Pi receives the same paired treatment across its complete TUI token set:
messages, tool states, Markdown, diffs, syntax highlighting, thinking levels,
bash mode, and HTML exports. Its automatic theme mode follows the terminal's
reported light or dark appearance.

The directory capsule keeps the full path visible, shortening only the home
folder to `~`.

Dreamlike Canopy uses 86% opacity. Dreamlike Glade uses a more translucent
78% with a 4.5:1 minimum contrast guard and deeper ANSI text colors. Both use
Ghostty's blur.

## Included

- `ghostty/themes/Dreamlike Canopy` — the dark Ghostty color theme
- `ghostty/themes/Dreamlike Glade` — the light Ghostty color theme
- `ghostty/config` — the companion Ghostty settings
- `starship/starship.toml` — adaptive Design A Starship configuration
- `codex/themes/Dreamlike Canopy` — importable dark Codex app theme
- `codex/themes/Dreamlike Glade` — importable light Codex app theme
- `pi/themes/dreamlike-canopy.json` — dark Pi TUI and export theme
- `pi/themes/dreamlike-glade.json` — light Pi TUI and export theme
- `scripts/install.sh` — installs with timestamped backups
- `scripts/rollback.sh` — restores the latest package backup
- `tests/validate.sh` — syntax and isolated install/rollback checks

## Requirements

- macOS with Ghostty installed
- Starship installed and initialized by your shell
- Codex app with Appearance theme import support (for the optional Codex pair)
- Pi coding agent with custom theme support (for the optional Pi pair)
- GeistMono Nerd Font installed for the rounded Powerline glyphs
- Geist Mono is configured as the fallback font

### Verify the font

Check that the glyph-capable face is installed before using the default prompt:

```sh
fc-list | grep -i "GeistMono Nerd Font"
```

If this prints nothing, Powerline caps or the lock can appear as empty boxes (tofu).
Install GeistMono Nerd Font, or use the plain-glyph profile below.

For zsh, initialize Starship with this line in `~/.zshrc` if it is not there
already:

```sh
eval "$(starship init zsh)"
```

## Install

From the extracted package directory, run:

```sh
./scripts/install.sh
```

The installer replaces only these four files, writing through any existing
non-dangling symlink so a dotfiles manager keeps owning the destination. It
preserves each previous target version in `~/.config/dreamlike-canopy-backups/<timestamp>/`:

- `~/.config/ghostty/config`
- `~/.config/ghostty/themes/Dreamlike Canopy`
- `~/.config/ghostty/themes/Dreamlike Glade`
- `~/.config/starship.toml`

The installer stages all four files before replacing any destination. If a commit
fails, it restores the timestamped backup; if recovery cannot complete, run the
printed `TARGET_HOME=... ./scripts/rollback.sh` command.

Restart Ghostty completely (not merely a new terminal window), then open a
new shell. On macOS, Ghostty applies opacity changes only after a full restart.

## Import into Codex

Codex app themes are imported from share strings instead of installed as files:

1. Open **Codex → Settings → Appearance**.
2. In the light theme section, choose **Import**, paste the complete contents
   of `codex/themes/Dreamlike Glade`, and choose **Import theme**.
3. In the dark theme section, choose **Import**, paste the complete contents
   of `codex/themes/Dreamlike Canopy`, and choose **Import theme**.
4. Set the app appearance to **System** to switch between Glade and Canopy with
   macOS Appearance.

The Codex share format pairs custom application chrome with one of Codex's
built-in code themes. Glade uses Proof and Canopy uses Everforest because they
retain the closest light and dark syntax relationships while the custom chrome
supplies the exact Dreamlike surfaces, foregrounds, accents, diff colors, and
Geist Mono stack. Both themes keep the sidebar translucent. Glade's UI accent
uses the palette's deeper green (`#2F7550`) so small controls retain at least
4.5:1 contrast against the glade surface.

## Install into Pi

Copy both JSON files into Pi's global theme directory:

```sh
mkdir -p ~/.pi/agent/themes
cp pi/themes/dreamlike-glade.json ~/.pi/agent/themes/
cp pi/themes/dreamlike-canopy.json ~/.pi/agent/themes/
```

Then open `/settings`, set the theme mode to **Automatic**, choose
`dreamlike-glade` for light and `dreamlike-canopy` for dark. The equivalent
`~/.pi/agent/settings.json` value is:

```json
{
  "theme": "dreamlike-glade/dreamlike-canopy"
}
```

Pi inherits its live TUI background from the terminal, so use this pair with
the matching Ghostty themes for the intended surfaces. HTML exports do not
inherit terminal colors; both JSON files therefore define explicit page, card,
and informational backgrounds.

## Optional prompt profiles

### No Nerd Font

Use `starship/starship-plain.toml` to avoid Powerline and lock glyphs:

```sh
cp /path/to/dreamlike-canopy/starship/starship-plain.toml ~/.config/starship-plain.toml
echo 'export STARSHIP_CONFIG="$HOME/.config/starship-plain.toml"' >> ~/.zshrc
```

Open a new shell after this opt-in choice. This profile does not affect
Ghostty's automatic light/dark switching.

### Transient completed prompts (Zsh)

To replace each completed full prompt with the mint success or Rose error
prompt character, source the included self-contained Zsh hook **after** Starship
initialization. It does not require a plugin manager or another transience helper:

```sh
eval "$(starship init zsh)"
source /path/to/dreamlike-canopy/starship/transient-zsh.zsh
```

The active prompt remains full; only completed prompts collapse to the colored
character.

## Switch light and dark mode

Ghostty uses this theme pair:

```ini
theme = light:Dreamlike Glade,dark:Dreamlike Canopy
```

Choose Light, Dark, or Auto in macOS System Settings → Appearance. Ghostty
will follow the system setting; new terminals use the selected palette.

## Roll back

To restore the most recent backup created by the installer:

```sh
./scripts/rollback.sh
```

## Validate locally

Before installing or importing, run the included validation suite:

```sh
./tests/validate.sh
```

It loads the Starship TOML with `starship print-config`, renders the directory
module to verify both rounded caps, checks both Ghostty themes and all 16 ANSI
entries, verifies the per-theme opacity and contrast settings, checks both
scripts with `sh -n`, validates the Codex share strings and Pi theme schemas,
semantic colors, and contrast, and exercises installation plus rollback in
temporary homes. If the
`ghostty` CLI is available, the suite also runs Ghostty's
`+validate-config` parser on the main configuration and both theme files.

## Git status symbols

The prompt uses both symbols and color so status remains understandable without
color perception. Rose marks destructive states, sunlight marks attention,
and green marks staged progress. Remote synchronization is shown in sunlight.

| Symbol | Meaning | Color role |
| --- | --- | --- |
| `~` | conflicted | rose |
| `✘` | deleted | rose |
| `!` | modified | sunlight |
| `»` | renamed | sunlight |
| `⇕` | diverged | sunlight |
| `⇣` | behind | sunlight |
| `⇡` | ahead | sunlight |
| `+` | staged | canopy green |
| `?` | untracked | mist |
| `≡` | stashed | mist |

## Troubleshooting missing glyphs

The directory capsule (`` and ``) and read-only lock (``) require
**GeistMono Nerd Font**. Install that font, then fully restart Ghostty. If the
glyphs still render as empty boxes, confirm the font is installed in Font Book
and that `ghostty/config` lists `GeistMono Nerd Font` before the Geist Mono
fallback.
