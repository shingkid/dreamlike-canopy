---
name: Dreamlike Canopy Terminal System
description: An adaptive Ghostty and Starship system pairing nocturnal forest depth with an airy glade.
colors:
  canopy-background: "#07110F"
  canopy-foreground: "#D9E6E3"
  canopy-mint: "#8FFFD2"
  canopy-selection: "#1D4C47"
  glade-background: "#E7F0E8"
  glade-foreground: "#1F4249"
  glade-cursor: "#2D8D6C"
  glade-selection: "#D8D0E2"
  rose: "#C96F78"
  green: "#7FE3B2"
  sunlight: "#E8D79A"
  blue: "#6794D8"
  violet: "#9B86D3"
  lagoon: "#52D9D0"
  muted-teal: "#718A88"
  deep-teal: "#24514D"
  glade-rose: "#8E3D50"
  glade-green: "#2F7550"
  glade-sunlight: "#86601F"
  glade-blue: "#365F91"
  glade-violet: "#624781"
  glade-lagoon: "#216D72"
  glade-muted-teal: "#506864"
typography:
  body:
    fontFamily: "GeistMono Nerd Font, Geist Mono, monospace"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.4
rounded:
  capsule: "0px"
spacing:
  window-x: "18px"
  window-y: "14px"
components:
  terminal-surface:
    backgroundColor: "{colors.canopy-background}"
    textColor: "{colors.canopy-foreground}"
    padding: "{spacing.window-y} {spacing.window-x}"
  directory-capsule:
    backgroundColor: "{colors.deep-teal}"
    textColor: "{colors.canopy-foreground}"
    rounded: "{rounded.capsule}"
    padding: "0 1ch"
---

# Design System: Dreamlike Canopy Terminal System

## Overview

**Creative North Star: “A forest observatory after dusk.”**

Dreamlike Canopy treats the terminal as a quiet instrument panel inside a living forest: dark mode is a deep blue-green canopy, while light mode opens into a misty glade. The paired palettes preserve the same ANSI semantics, so the shell prompt, Git state, runtimes, and command feedback remain familiar as macOS Appearance changes.

The system is atmospheric but practical. Translucency, blur, and luminous mint are reserved for the terminal surface and prompt affordances; command output remains high-contrast and readable. It is neither a generic neon hacker theme, a glossy SaaS dashboard, nor decorative glass UI.

**Key Characteristics:**

- Deep forest teal in dark mode; an open green-tinted neutral in light mode.
- Shared ANSI semantics across automatic light/dark switching.
- Geist Mono at a stable 14px reading size.
- Full paths, explicit Git symbols, and a Powerline directory capsule.

## Colors

The palette is a semantic forest spectrum: teal and mint establish place, violet and blue distinguish context, sunlight marks attention, and rose signals failure without overtaking the terminal.

### Primary

- **Canopy Night:** The dark terminal background and deepest surface.
- **Canopy Mint:** Cursor, successful prompt, and bright positive state.
- **Glade Teal:** Light-mode cursor and primary green accent.

### Secondary

- **Lagoon:** Runtime and language context in dark mode.
- **Violet:** Branch context and secondary identity.
- **Sky Blue:** Informational ANSI state.

### Tertiary

- **Sunlight:** Duration and Git attention state in dark mode.
- **Rose:** Error and destructive feedback.

### Neutral

- **Canopy Mist:** Dark-mode foreground and bright text.
- **Glade Background:** Light-mode terminal surface.
- **Glade Ink:** Light-mode foreground and strongest text.
- **Deep Teal:** Dark selection family and directory-capsule source color.
- **Lavender Selection:** Light-mode selection surface.
- **Muted Teal:** Low-emphasis context in each theme.

**The Shared Semantics Rule.** A light/dark switch may change a color’s value, never its ANSI meaning. Branch, runtime, duration, success, and error assignments stay stable across both themes.

**The Risk Signal Rule.** Rose is reserved for conflict and deletion; sunlight marks modification and remote synchronization; green marks staged progress. Symbols remain visible so risk is never communicated by color alone.

## Typography

**Display Font:** None; this is a terminal-native system.
**Body Font:** Geist Mono, with GeistMono Nerd Font as the glyph-capable face.
**Label/Mono Font:** GeistMono Nerd Font, Geist Mono, monospace.

**Character:** Monospaced, calm, and information-dense without becoming compressed. The Nerd Font face supplies Powerline separators and the lock icon; the fixed reading size keeps paths and status strings scannable.

### Hierarchy

- **Body** (400, 14px, 1.4 line-height): Shell output and prompt content.
- **Label** (400, inherited 14px): Git, runtime, package, time, and duration context.
- **Prompt character** (400, inherited 14px): Mint success, rose error, and green Vim-command state.

**The Instrument Rule.** Do not introduce display faces, proportional labels, or variable headline scales. Hierarchy comes from spacing, semantic color, and module order.

## Elevation

The system uses atmospheric depth rather than card shadows. Ghostty applies a 20px background blur; Canopy is 86% opaque and Glade is 78% opaque, each with a 4.5 minimum-contrast guard. The terminal remains one continuous surface, with depth supplied by the backdrop and the directory capsule—not floating panels.

**The One-Surface Rule.** Keep the terminal visually continuous. Use opacity, blur, selection, and the directory capsule for state; never add shadowed cards or decorative glass containers.

## Components

### Terminal Surface

- **Shape:** Continuous window surface with no card radius.
- **Background:** Canopy Night in dark mode; Glade Background in light mode.
- **Atmosphere:** 20px background blur; 0.86 dark and 0.78 light opacity.
- **Padding:** 18px horizontal and 14px vertical.

### Directory Capsule

- **Shape:** Powerline opening and closing caps, not a rounded CSS box.
- **Color:** Bright-black ANSI background with bright-white ANSI text; it becomes deep teal in Canopy and lavender in Glade.
- **Behavior:** Shows the full path, shortening only the home folder to `~`.
- **Spacing:** One character of internal horizontal padding and two spaces before the next module.

### Status Modules

- **Git:** Violet branch name; rose for conflicted/deleted, sunlight for modified/renamed/diverged/ahead/behind, green for staged, and mist for untracked/stashed. Every state has an explicit symbol.
- **Runtimes:** Lagoon/cyan for Node, Python, Rust, and Go versions.
- **Time and duration:** Mist for the clock; sunlight/yellow for commands taking at least two seconds.
- **Prompt state:** Mint success, rose error, and green Vim-command state.

## Do's and Don'ts

### Do:

- **Do** preserve the `light:Dreamlike Glade,dark:Dreamlike Canopy` pairing so the system follows macOS Appearance.
- **Do** use ANSI semantic roles so Starship adapts with Ghostty automatically.
- **Do** retain the 4.5 minimum-contrast guard and Glade’s deep teal ink.
- **Do** keep the full working path visible and truncate only the home directory to `~`.
- **Do** retain 18px / 14px window padding and 20px blur as the environmental frame.
- **Do** reserve rose for destructive Git states and prompt errors; reserve sunlight for duration and Git attention states.

### Don't:

- **Don't** introduce a separate light-mode Starship configuration; semantic ANSI colors are the adaptive bridge.
- **Don't** use neon accents, gradient text, or saturated decoration that competes with command output.
- **Don't** add floating cards, wide shadows, or default glassmorphism layers to a one-surface terminal.
- **Don't** shorten directory paths with `…/`; the design keeps the full path visible.
- **Don't** change an ANSI color’s meaning between Canopy and Glade.
- **Don't** use display fonts, proportional UI labels, or arbitrary rounded containers in the terminal system.
