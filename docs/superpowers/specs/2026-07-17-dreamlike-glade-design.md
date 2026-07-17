# Dreamlike Glade Light Theme Design

**Status:** Implemented and contrast-tuned.

## Pairing and intent

- Dark theme: `Dreamlike Canopy`
- Light theme: `Dreamlike Glade`
- Ghostty pairing: `theme = light:Dreamlike Glade,dark:Dreamlike Canopy`

Dreamlike Canopy remains the enclosed, nocturnal forest. Dreamlike Glade is
its open, sunlit counterpart: pale leaf mist, deep forest ink, sky blue,
wisteria, emerald, muted sunlight, and restrained floral coral. The light
theme must feel like the same place with space between the trees, not like an
unrelated neutral theme.

## Reference sampling

The hue anchors were sampled approximately from two Hiroo Isono forest
references:

- Noritake Forest exhibition image:
  <https://www.noritake.co.jp/mori/look/gallery_detail/191/>
- “Into the Depths of the Sacred Forest” gallery:
  <https://doorofperception.com/2016/11/hiro-isono-into-the-depths-of-the-sacred-forest/>

Representative sampled anchors included forest teal `#1F4249`, leaf green
`#296F49` and `#5BA075`, sky blue `#5697BF`, wisteria `#8C76B1`, and pale leaf
green `#8FBE9D`. These are pixel-derived approximations, not an official
artist palette. The terminal colors below lift, tint, or darken those anchors
to preserve contrast on a light background.

## Ghostty palette

Core surface colors:

- Background: `#E7F0E8` — pale leaf mist
- Foreground: `#1F4249` — deep forest teal
- Cursor: `#2D8D6C` — emerald
- Cursor text: `#E7F0E8`
- Selection background: `#D8D0E2` — lavender mist
- Selection foreground: `#1F4249`

Normal ANSI colors:

| Index | Role | Color |
|---:|---|---|
| 0 | Forest black | `#244B4B` |
| 1 | Deep floral red | `#8E3D50` |
| 2 | Leaf green | `#2F7550` |
| 3 | Filtered sunlight | `#86601F` |
| 4 | Sky blue | `#365F91` |
| 5 | Shaded wisteria | `#624781` |
| 6 | Lagoon teal | `#216D72` |
| 7 | Mist gray | `#506864` |

Bright ANSI colors:

| Index | Role | Color |
|---:|---|---|
| 8 | Lavender-glass capsule | `#D5CDE3` |
| 9 | Floral coral | `#9C4357` |
| 10 | Luminous emerald | `#1F6B4E` |
| 11 | Warm sunlight | `#805815` |
| 12 | Clear sky | `#345F97` |
| 13 | Wisteria | `#73549D` |
| 14 | Clear lagoon | `#1F686C` |
| 15 | Capsule text | `#1F4249` |

The primary foreground has a contrast ratio of approximately 9.3:1 against
the background. The tuned mist, green, gold, blue, and cyan colors exceed
5:1 against the nominal background, and Ghostty enforces a 4.5:1 minimum
contrast when translucency changes the effective surface color. Lavender is
concentrated in selection, the directory capsule, and Git/violet accents so
the palette retains its forest identity.

## Starship behavior

The existing Design A layout remains unchanged: full-path rounded directory
capsule, airy Git and status modules, clean second-line prompt, and faint
right-side clock. Starship continues using semantic ANSI colors so it adapts
automatically when Ghostty switches themes. In Dreamlike Glade, ANSI bright
black becomes the pale lavender capsule and ANSI bright white becomes deep teal
capsule text.

## Configuration and installation

- Replace the `Frosted Pearl` theme file with `Dreamlike Glade`.
- Update Ghostty’s light/dark theme pair to the new name.
- Update installer and rollback scripts to back up, install, restore, or
  remove `Dreamlike Glade` correctly.
- Set Dreamlike Canopy to 86% opacity and Dreamlike Glade to 78% opacity.
- Apply a 4.5:1 minimum contrast guard only to Dreamlike Glade.
- Keep blur 20, font settings, padding, and all dark-theme colors unchanged.
- Update documentation to explain macOS Appearance switching.

## Validation

- Parse the Ghostty config and both theme files with Ghostty’s own validator.
- Parse and render Starship with the current Starship binary.
- Require exactly 16 ANSI entries in each theme.
- Test install and rollback in isolated homes with both pre-existing and
  previously absent light-theme files.
- Rebuild the archive, extract it into a fresh temporary directory, and run
  the full validation suite from the extracted copy.

## Out of scope

- No changes to Dreamlike Canopy’s current colors.
- No changes to the Starship module layout or directory-path behavior.
- No shell startup-file edits and no modification of live user configuration.
