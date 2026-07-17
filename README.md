# Dreamlike Canopy — Ghostty + Starship

This package pairs dark Dreamlike Canopy with its light Dreamlike Glade
companion and the Design A Starship prompt. Dreamlike Glade uses forest teal,
leaf green, sky blue, and wisteria sampled from Hiroo Isono forest paintings,
with a lavender-glass directory capsule and selection. The colors are lifted
and adjusted for a readable light terminal. Ghostty follows the
current macOS Appearance automatically. Starship uses the themes' ANSI colors,
so its rounded directory capsule, Git context, status, runtimes, and prompt
character adapt at the same time without a separate light-mode configuration.

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
- `scripts/install.sh` — installs with timestamped backups
- `scripts/rollback.sh` — restores the latest package backup
- `tests/validate.sh` — syntax and isolated install/rollback checks

## Requirements

- macOS with Ghostty installed
- Starship installed and initialized by your shell
- GeistMono Nerd Font installed for the rounded Powerline glyphs
- Geist Mono is configured as the fallback font

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

The installer replaces only these four files, preserving their previous
versions in `~/.config/dreamlike-canopy-backups/<timestamp>/`:

- `~/.config/ghostty/config`
- `~/.config/ghostty/themes/Dreamlike Canopy`
- `~/.config/ghostty/themes/Dreamlike Glade`
- `~/.config/starship.toml`

Restart Ghostty completely (not merely a new terminal window), then open a
new shell. On macOS, Ghostty applies opacity changes only after a full restart.

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

Before installing, run the included validation suite:

```sh
./tests/validate.sh
```

It loads the Starship TOML with `starship print-config`, renders the directory
module to verify both rounded caps, checks both Ghostty themes and all 16 ANSI
entries, verifies the per-theme opacity and contrast settings, checks both
scripts with `sh -n`, and exercises installation plus rollback in temporary
homes. If the `ghostty` CLI is available, the suite also runs Ghostty's
`+validate-config` parser on the main configuration and both theme files.

## Git status symbols

The prompt uses both symbols and color so status remains understandable without
color perception. Coral marks destructive states, sunlight marks attention,
and green marks positive progress.

| Symbol | Meaning | Color role |
| --- | --- | --- |
| `~` | conflicted | coral |
| `✘` | deleted | coral |
| `!` | modified | sunlight |
| `»` | renamed | sunlight |
| `⇕` | diverged | sunlight |
| `⇣` | behind | sunlight |
| `⇡` | ahead | canopy green |
| `+` | staged | canopy green |
| `?` | untracked | mist |
| `≡` | stashed | mist |

## Troubleshooting missing glyphs

The directory capsule (`` and ``) and read-only lock (``) require
**GeistMono Nerd Font**. Install that font, then fully restart Ghostty. If the
glyphs still render as empty boxes, confirm the font is installed in Font Book
and that `ghostty/config` lists `GeistMono Nerd Font` before the Geist Mono
fallback.
