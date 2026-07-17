---
name: Dreamlike Canopy Terminal System
description: A translucent forest-terminal system pairing a deep nocturnal palette with an airy glade companion.
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

Dreamlike Canopy treats the terminal as a quiet instrument panel inside a living
forest: dark mode is a deep blue-green canopy, while light mode opens into a
misty glade. The two palettes share semantic ANSI roles so the shell prompt,
Git state, runtimes, and command feedback remain familiar as the ambient theme
changes.

The system is atmospheric but practical. Translucency, blur, and luminous mint
are reserved for the terminal surface and prompt affordances; content remains
high-contrast and readable. It should feel composed and tactile, never like a
generic neon hacker theme, a glossy SaaS dashboard, or decorative glass UI.

**Key Characteristics:**

- Deep forest teal in dark mode; open green-tinted neutral in light mode.
- Shared ANSI semantics across automatic light/dark switching.
- Geist Mono typography at a stable 14px reading size.
- Full paths, compact status modules, and a rounded Powerline directory capsule.

## Colors

The palette is a full semantic forest spectrum: teal and mint establish the
environment, violet and blue separate contextual states, sunlight marks time or
duration, and rose signals errors without overwhelming the surface.

### Primary

- **Canopy Night** (#07110F): Dark terminal background and the deepest surface.
- **Canopy Mint** (#8FFFD2): Cursor, successful prompt, and bright positive state.
- **Glade Teal** (#2D8D6C): Light-mode cursor and primary green accent.

### Secondary

- **Lagoon** (#52D9D0): Runtime and language context in dark mode.
- **Violet** (#9B86D3): Branch context and secondary identity.
- **Sky Blue** (#6794D8): ANSI informational blue.

### Tertiary

- **Sunlight** (#E8D79A): Duration and time context in dark mode.
- **Rose** (#C96F78): Error and failure feedback.

### Neutral

- **Canopy Mist** (#D9E6E3): Dark-mode foreground and bright text.
- **Glade Background** (#E7F0E8): Light-mode terminal surface.
- **Glade Ink** (#1F4249): Light-mode foreground and strongest text.
- **Deep Teal** (#24514D): Directory capsule and dark selection family.
- **Lavender Selection** (#D8D0E2): Light-mode selection surface.
- **Muted Teal** (#718A88 / #506864): Secondary ANSI text and low-emphasis context.

### Named Rules

**The Glade Differentiation Rule.** Dreamlike Glade separates terminal
status categories through hue families first: rose for failures, forest
green for success, ochre for time or warnings, blue for information,
violet for contextual identity, lagoon for runtimes, and muted teal for
low-emphasis metadata. Bright ANSI entries intensify the same role rather
than introduce a second meaning. Text-capable ANSI entries must maintain
at least 4.5:1 contrast against the Glade background; bright black is
reserved as the directory-capsule surface.

**The Shared Semantics Rule.** A light/dark switch may change the actual color,
but never the meaning of an ANSI role. Keep branch, runtime, duration, success,
and error assignments stable across both themes.

## Typography

**Display Font:** None; this is a terminal-native system.
**Body Font:** Geist Mono, with Geist Mono Nerd Font as the glyph-capable face.
**Label/Mono Font:** GeistMono Nerd Font, Geist Mono, monospace.

**Character:** Monospaced, calm, and information-dense without becoming
compressed. The Nerd Font face supplies Powerline separators and the lock icon;
the stable 14px size keeps paths and status strings scannable.

### Hierarchy

- **Body** (400, 14px, 1.4 line-height): Shell output and prompt content.
- **Label** (400, inherited 14px): Git, runtime, package, time, and duration context.
- **Prompt character** (400, inherited 14px): Mint success, coral error, and canopy Vim-command states.

### Named Rules

**The Instrument Rule.** Do not introduce display faces, proportional labels, or
variable headline scales into the terminal configuration. Hierarchy comes from
spacing, semantic color, and module order.

## Elevation

The system uses atmospheric depth rather than card shadows. Ghostty supplies a
20px background blur and each theme controls its own translucency: 86% for
Canopy and 78% for Glade. The terminal remains one continuous surface; depth is
created by the backdrop and the darker directory capsule, not floating panels.

### Named Rules

**The One-Surface Rule.** Keep the terminal visually continuous. Use opacity,
blur, selection, and the directory capsule for state; do not add shadowed card
layers or decorative glass containers.

## Components

### Terminal Surface

- **Shape:** A continuous window surface with no card radius.
- **Background:** Canopy Night in dark mode; Glade Background in light mode.
- **Opacity:** 0.86 dark / 0.78 light.
- **Atmosphere:** 20px background blur.
- **Padding:** 18px horizontal and 14px vertical.

### Directory Capsule

- **Shape:** Powerline opening and closing caps, visually capsule-like rather than a rounded CSS box.
- **Color:** Deep Teal / bright-black background with mist / bright-white text.
- **Behavior:** Shows the full path, shortening only the home folder to `~`.
- **Spacing:** One character of internal horizontal padding and two spaces before the next module.

### Status Modules

- **Git:** Violet branch name; canopy green status symbols; explicit symbols for modified, staged, deleted, ahead, behind, and diverged states.
- **Runtimes:** Lagoon/cyan for Node, Python, Rust, and Go versions.
- **Time and duration:** Mist for the clock; sunlight/yellow for commands taking at least two seconds.
- **Prompt state:** Mint success, coral error, and canopy Vim-command state.

## Do's and Don'ts

### Do:

- **Do** preserve the `light:Dreamlike Glade,dark:Dreamlike Canopy` pairing so the system follows macOS Appearance.
- **Do** use ANSI semantic roles so Starship adapts with Ghostty automatically.
- **Do** keep foreground contrast strong: Glade uses a 4.5 minimum contrast guard and deep teal ink.
- **Do** keep the full working path visible and truncate only the home directory to `~`.
- **Do** use the existing 18px / 14px window padding and 20px blur as the environmental frame.
- **Do** reserve rose/coral for errors and sunlight/yellow for time-related context.

### Don't:

- **Don't** introduce a separate light-mode Starship configuration; semantic ANSI colors are the adaptive bridge.
- **Don't** use neon accents, gradient text, or saturated decoration that competes with command output.
- **Don't** add floating cards, wide shadows, or default glassmorphism layers to a one-surface terminal.
- **Don't** shorten directory paths with `…/`; the design explicitly keeps the full path visible.
- **Don't** change the meaning of an ANSI color between Canopy and Glade.
- **Don't** use display fonts, proportional UI labels, or arbitrary rounded containers in the terminal system.
