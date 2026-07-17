# Dreamlike Glade Semantic ANSI Color Differentiation

## Goal

Improve fast visual differentiation in terminal status output—especially Codex status lines—without making Dreamlike Glade louder or changing the established meaning of its ANSI roles.

## Scope

- Update the sixteen ANSI entries in `ghostty/themes/Dreamlike Glade`.
- Preserve the existing Glade background, foreground, cursor, cursor text, selection colors, opacity, and `minimum-contrast = 4.5` guard.
- Preserve the existing Starship mapping: green/mint for positive state, rose/coral for failure, sunlight for duration, blue for information, violet for context, lagoon for runtimes, and muted teal for low-emphasis metadata.
- Update `DESIGN.md` to record the light-theme distinction strategy.
- Update static assertions in `tests/validate.sh` for any changed palette values.

## Out of Scope

- No Starship layout, symbol, module, or semantic-mapping changes.
- No Dreamlike Canopy changes.
- No changes to translucency, typography, or terminal window configuration.
- No separate Codex configuration; Codex receives the refinement through standard terminal ANSI colors.

## Palette Strategy

Dreamlike Glade remains a restrained, pale-green terminal surface. The change increases perceptual distance among semantic ANSI families rather than increasing saturation uniformly:

- **Rose/red:** failures and destructive status.
- **Forest green:** success and positive status.
- **Ochre/yellow:** duration, waiting, and warning-like emphasis.
- **Blue:** informational state.
- **Violet:** contextual identity such as branches.
- **Lagoon/cyan:** runtime and language context.
- **Muted teal:** secondary metadata.

Normal variants remain dark enough to read on Glade’s `#E7F0E8` background. Bright variants reinforce the same meaning with a visibly larger lightness/chroma step; they never introduce a new semantic category. The ANSI black and white entries continue to support terminal structure and Starship’s directory capsule.

## Implementation Boundaries

The Ghostty theme is the sole color-source module. Applications and Starship refer to ANSI color indices, so changing the theme improves Codex and shell output without coupling this package to any application-specific status-line implementation.

## Accessibility and Verification

- Confirm all changed ANSI colors intended for text meet at least 4.5:1 against `#E7F0E8` using relative luminance calculations.
- Retain Ghostty’s `minimum-contrast = 4.5` runtime guard.
- Keep semantic cues redundant with Codex/Starship text and symbols; color is a scanning aid, not the sole carrier of meaning.
- Run `./tests/validate.sh`, which parses Starship, validates Ghostty keys and all sixteen ANSI palette entries, and performs isolated install/rollback checks.
- Review the final ANSI table for distinct red/green, blue/violet, and cyan/green families at a glance.
