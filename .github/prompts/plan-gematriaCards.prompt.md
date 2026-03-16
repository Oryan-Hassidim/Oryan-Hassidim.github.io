## Plan: Gematria Cards with Near-Value Colors

Implement this as a full-directory 11ty site (Eleventy) with an Alpine.js Gematria page in [gimatria/index.html](gimatria/index.html), Material-style cards, dynamic sections, drag reorder, sorting, URL auto-persistence, and advanced color grouping. Equal totals share one color, while totals differing by exactly 1 use an almost-matching color by default (kollel-friendly), with a settings option to force exact same color for ±1. URL persistence uses a single `items=` parameter. All visible UI text (labels, buttons, placeholders, settings, helper text, validation messages, and empty states) is Hebrew with RTL direction.

**Steps**

1. Phase 1 - Minimal Material shell: Build a compact RTL-first layout with app bar, settings row, card list, and fixed bottom-left FAB; keep HTML/CSS/JS short and readable, and define Hebrew microcopy for all visible UI text.
2. Phase 2 - 11ty foundation for whole directory: initialize Eleventy with latest stable version, add `.eleventy.js`, `_includes`, `_layouts`, and passthrough settings; convert root and `gimatria` pages into Eleventy templates while preserving current routes.
3. Phase 3 - Modern JavaScript baseline: use latest stable JS features in browser-compatible ESM modules (`structuredClone`, modern array methods, and modern APIs such as `Intl.Segmenter`/`URLPattern` where relevant) with no legacy fallback layer.
4. Phase 4 - Hebrew UI localization enforcement: apply `lang="he"` and `dir="rtl"`, enforce Hebrew-only UI copy across templates and components, and ensure settings and status text stay Hebrew everywhere.
5. Phase 5 - Alpine state and hydration: define `sections`, `sortMode`, `gematriaMode`, `nearMode`, `nearDelta`, and drag state; hydrate from the single `items` payload and optional `sort`, `mode`, `near`, and `delta` params.
6. Phase 6 - Gematria core: implement Hebrew normalization and mapping with default standard final letters and optional large-final mode; if a token is all digits, use its numeric value directly; render single-word and multi-word expression formats.
7. Phase 7 - Card interactions: add, remove, and edit sections with live recompute and URL sync on every change.
8. Phase 8 - Drag reorder and sorting: implement drag-and-drop ordering plus sort by time or Gematria value with predictable behavior when switching modes.
9. Phase 9 - Advanced color grouping with modern CSS: use `oklch`, relative color syntax, `color-mix`, and where useful `attr()`, `sibling-count()`, and `sibling-index()`.
10. Equal totals use identical background token.
11. Totals differing by exactly 1 use near color controlled by `nearDelta` in `nearMode=almost`.
12. In `nearMode=same`, ±1 totals use the exact same background.
13. Phase 10 - View Transitions API: wrap add and remove actions with `document.startViewTransition(...)` as a required modern API path (no fallback branch).
14. Phase 11 - URL layer: persist sections and settings via a single `items` payload plus option params, with spaces serialized as underscores and URL values kept Hebrew-readable for sharing.
15. Phase 12 - Share flow and readable URL output: add a Hebrew-labeled Share button that shares/copies a human-readable link using Hebrew letters (not percent-escaped codes), with spaces normalized to underscores in serialized URL data.
16. Phase 13 - Validation: verify calculation examples, numeric-token behavior, color rules, Hebrew-only UI, sorting and reorder flow, readable share-link behavior, URL round-trip, and mobile FAB layout.

**Relevant files**

- `.eleventy.js` - Eleventy configuration and passthrough settings.
- `package.json` - latest Eleventy dependency and scripts (`dev`, `build`).
- `_includes/` and `_layouts/` - shared templates/layouts for full-directory 11ty structure.
- [gimatria/index.html](gimatria/index.html) - Gematria template with Alpine logic, Hebrew UI, color rules, sorting, URL sync, and transitions.
- [index.html](index.html) - converted for 11ty layout usage while preserving route behavior.

**Verification**

1. UI language check: all visible UI text is Hebrew and direction is RTL.
2. Enter שלום and verify output 376.
3. Enter אז שלום and verify output 8+376=384.
4. Enter an all-digits token (for example `123`) and verify its value is 123 in expression and total.
5. Create two sections with totals differing by 1 and verify near-matching backgrounds in default mode.
6. Switch `nearMode` to `same` and verify ±1 sections now share exact same background.
7. Move `nearDelta` slider and verify near-color distance changes visibly but remains related.
8. Add/remove sections and verify transitions run through the View Transitions API path.
9. Reorder by drag, refresh, and verify state is restored from URL.
10. Switch sort modes and verify ordering logic is stable.
11. Use the Share button and verify the shared link string contains Hebrew letters (not percent-escaped sequences), uses underscores for spaces, and restores state correctly when opened.
12. Run Eleventy dev/build scripts and verify routes and assets render correctly.

**Decisions**

- UI language is Hebrew for all user-facing text.
- Layout direction is RTL by default.
- Reorder method remains drag-and-drop.
- URL uses a single `items` parameter for section data.
- Use latest stable Eleventy for the whole directory.
- Use modern JavaScript in ESM-first style without legacy fallback branches.
- Any token that is all digits contributes its numeric value directly.
- Final-letter Gematria defaults to standard values, with optional large-final mode.
- Totals differing by exactly 1 are near-matched by default, with optional exact same color mode.
- Near-color tuning is user-controlled with a slider.
- Use modern CSS color/data functions where useful (`oklch`, relative color syntax, `color-mix`, `attr()`, `sibling-count()`, `sibling-index()`).
- Add a Hebrew-labeled Share button that shares/copies a readable link string.
- In serialized URL data, spaces are represented as underscores.
- Share output must keep Hebrew letters readable rather than percent-escaped sequences.

**Further Considerations**

1. No browser fallback layer for newer CSS/JS APIs: target modern platform behavior only.
2. Treat drag order as canonical for time mode; Gematria mode is computed.
3. Do not add local persistence fallback for long URLs; keep URL-only persistence model.
