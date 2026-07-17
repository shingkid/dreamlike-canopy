# Dreamlike Glade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Frosted Pearl with the approved Hiroo Isono–sampled Dreamlike Glade light theme while preserving Dreamlike Canopy and the Design A prompt.

**Architecture:** Ghostty selects `Dreamlike Glade` or `Dreamlike Canopy` from macOS Appearance. Starship continues using semantic ANSI colors, so the same prompt configuration adapts to whichever Ghostty palette is active. Installer and rollback scripts treat the renamed light theme as a first-class managed file.

**Tech Stack:** Ghostty 1.3 configuration, Starship TOML, POSIX shell scripts, tar/gzip.

## Global Constraints

- Dark theme name remains exactly `Dreamlike Canopy`.
- Light theme name becomes exactly `Dreamlike Glade`.
- Ghostty pairing is exactly `theme = light:Dreamlike Glade,dark:Dreamlike Canopy`.
- Preserve 89% opacity, blur 20, fonts, padding, full-path capsule, Starship layout, and current Dreamlike Canopy colors.
- Do not edit live Ghostty, Starship, or shell startup files.
- The workspace is not a Git repository; use diff and validation checkpoints instead of commit steps.

---

### Task 1: Lock the rename and palette in regression checks

**Files:**
- Modify: `tests/validate.sh`

**Interfaces:**
- Consumes: package-local Ghostty config, theme files, installer, and rollback scripts.
- Produces: one executable validation suite that fails until Dreamlike Glade is fully integrated.

- [ ] **Step 1: Point the light-theme fixture at Dreamlike Glade**

Set:

```sh
GHOSTTY_LIGHT_THEME_FILE="$PACKAGE_DIR/ghostty/themes/Dreamlike Glade"
```

- [ ] **Step 2: Require the new pairing and sampled core colors**

Add assertions for:

```sh
assert_contains "$GHOSTTY_CONFIG_FILE" 'theme = light:Dreamlike Glade,dark:Dreamlike Canopy'
assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'background = #E7F0E8'
assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'foreground = #1F4249'
assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'cursor-color = #2D8D6C'
assert_contains "$GHOSTTY_LIGHT_THEME_FILE" 'selection-background = #C9DDD4'
```

Update isolated-home fixture paths and messages from `Frosted Pearl` to `Dreamlike Glade`.

- [ ] **Step 3: Run the suite and observe the expected failure**

Run: `./tests/validate.sh`

Expected: FAIL because `ghostty/themes/Dreamlike Glade` and the new config pairing do not exist yet.

---

### Task 2: Implement Dreamlike Glade and installation lifecycle

**Files:**
- Create: `ghostty/themes/Dreamlike Glade`
- Delete: `ghostty/themes/Frosted Pearl`
- Modify: `ghostty/config`
- Modify: `scripts/install.sh`
- Modify: `scripts/rollback.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: the semantic ANSI roles in `starship/starship.toml`.
- Produces: an automatically selected light theme and reversible installation behavior.

- [ ] **Step 1: Create the exact Dreamlike Glade palette**

Use:

```ini
background = #E7F0E8
foreground = #1F4249
cursor-color = #2D8D6C
cursor-text = #E7F0E8
selection-background = #C9DDD4
selection-foreground = #1F4249
palette = 0=#244B4B
palette = 1=#8E3D50
palette = 2=#2F7550
palette = 3=#86601F
palette = 4=#365F91
palette = 5=#5D477E
palette = 6=#216D72
palette = 7=#60746F
palette = 8=#C5DCCB
palette = 9=#9C4357
palette = 10=#257B5B
palette = 11=#946C25
palette = 12=#3F6FA8
palette = 13=#6A518F
palette = 14=#28777A
palette = 15=#1F4249
```

- [ ] **Step 2: Replace the Ghostty pairing**

Set:

```ini
theme = light:Dreamlike Glade,dark:Dreamlike Canopy
```

- [ ] **Step 3: Rename installer and rollback targets**

The installer must back up and install:

```sh
backup_file "$GHOSTTY_DIR/themes/Dreamlike Glade" dreamlike-glade-theme
cp "$SOURCE_DIR/ghostty/themes/Dreamlike Glade" "$GHOSTTY_DIR/themes/Dreamlike Glade"
```

The rollback script must restore:

```sh
restore_file dreamlike-glade-theme "$GHOSTTY_DIR/themes/Dreamlike Glade"
```

- [ ] **Step 4: Update user documentation**

Replace Frosted Pearl naming and paths with Dreamlike Glade. Explain that macOS Appearance chooses between the two themes and that Starship follows the active ANSI palette.

- [ ] **Step 5: Run the complete working-tree validation**

Run: `./tests/validate.sh`

Expected: `All configuration and installer checks passed.` with exit code 0.

- [ ] **Step 6: Confirm the dark theme did not change**

Run a file comparison between the pre-change output copy and working copy of `ghostty/themes/Dreamlike Canopy`.

Expected: no diff.

---

### Task 3: Rebuild and verify the distributable archive

**Files:**
- Update: `outputs/dreamlike-canopy-ghostty-starship/`
- Update: `outputs/dreamlike-canopy-ghostty-starship.tar.gz`

**Interfaces:**
- Consumes: the validated working package.
- Produces: the downloadable archive and checksum.

- [ ] **Step 1: Synchronize the output folder**

Copy all working-package files to the output folder and explicitly remove the stale `ghostty/themes/Frosted Pearl` output file. Confirm `ghostty/themes/Dreamlike Glade` exists.

- [ ] **Step 2: Rebuild the archive**

Run:

```sh
tar -czf outputs/dreamlike-canopy-ghostty-starship.tar.gz \
  -C outputs dreamlike-canopy-ghostty-starship
```

- [ ] **Step 3: Inspect archive membership**

Run: `tar -tzf outputs/dreamlike-canopy-ghostty-starship.tar.gz | sort`

Expected: includes `ghostty/themes/Dreamlike Glade`; does not include `ghostty/themes/Frosted Pearl`.

- [ ] **Step 4: Validate from a fresh extraction**

Extract into a directory made by `mktemp -d`, run the extracted `tests/validate.sh`, and verify the config and four sampled core colors with `rg`.

Expected: all checks pass with exit code 0.

- [ ] **Step 5: Generate the final checksum**

Run: `shasum -a 256 outputs/dreamlike-canopy-ghostty-starship.tar.gz`

Expected: one SHA-256 digest for the final archive.
