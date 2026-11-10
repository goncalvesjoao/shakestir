# Semanticus CSS migration and suggested additions

Initial audit reviewed 2026-11-07 against the [Semanticus documentation](https://semanticus.design/docs/) and the actual vendored Semanticus **3.2.2** stylesheet. The neighboring `semanticus-css` source checkout was used to understand implementations; availability was checked against the Rails bundle. The initial migration did not upgrade the framework. A subsequent update now vendors the published **3.3.0** release and adopts its `.size-*` modifiers, as described below. No edits to the framework repository are included.

## Result

Across the six application stylesheets, declarations decreased from **2,236 to 2,054**: **182 fewer (8.1%)**. Uncompressed application CSS decreased from **74,896 to 71,441 bytes**, saving **3,455 bytes (4.6%)**. Counts include custom properties. This is CSS reduction, not a claim about total transfer size: utility names add HTML bytes, and gzip/compression was not measured.

Replaced repeated display, alignment, wrapping, positioning, image-fit, circular-radius, overflow, zero-spacing and sizing declarations with existing utilities. Migrated collection grids, recipe reference grids and technique options to `.auto-grid`, keeping their original dimensions, gaps and responsive behavior through its custom properties. Updated dynamically constructed collection choices as well as ERB templates. Existing application class names remain as styling and behavior hooks.

Examples of the existing API now used:

| CSS responsibility | Semanticus API |
| --- | --- |
| Flex/grid display and alignment | `d-flex`, `d-inline-flex`, `d-grid`, `align-items-*`, `justify-content-*`, `flex-wrap` |
| Positioning | `position-relative`, `position-absolute`, `position-fixed` |
| Image sizing and fitting | `w-100`, `h-100`, `mw-100`, `object-fit-cover` |
| Clipping, scrolling, circular shapes | `overflow-hidden`, `overflow-y-auto`, `rounded-circle` |
| Resets and alignment | `m-0`, `p-0`, `shadow-none`, `text-center`, `text-start` |
| Repeated responsive grids | `auto-grid`, `--auto-grid-type`, `--auto-grid-min-column`, `--auto-grid-gap` |

The migration follows the existing [utilities](https://semanticus.design/docs/utilities/flexbox) and [auto-grid](https://semanticus.design/docs/components/auto-grid) APIs.

## Why other declarations remain

Most remaining CSS describes actual product design: cover washes and crops, page widths, unequal mixing/editor columns, control sizes, typography, state styling, and responsive changes. Replacing those with approximately matching utilities would change the design.

Spacing is a particularly large mismatch. Semanticus defaults `--spacing` to `.75rem`; its numbered scale produces `.1875`, `.375`, `.75`, `1.125`, and `2.25rem`. This app commonly uses `.5`, `1`, `1.5`, and `2rem`, with local overrides of `--spacing` in forms. `gap-3` is therefore not a replacement for a 1rem gap. Globally changing `--spacing` would also change semantic component spacing.

Utilities generally use `!important`. During browser verification, `m-0` on library secondary buttons suppressed contextual mobile indentation and collection-detail spacing; `m-0` on search pickers defeated the framework's search-group margin adjustment; `w-100` overrode the hidden progress indicator's 1px width; and `rounded-circle` overrode search-group corner treatment. Those replacements were removed. Display remains in custom CSS where print, dialog visibility or contextual rules need to override it.

Color utilities also do more than assign a foreground: for example, `text-muted` changes `--typography-color`. Applying it to a wrapper can affect descendants. Existing direct color rules were retained where that inheritance would change the result.

## Suggested Semanticus additions, in priority order

Names below are **proposed APIs**, not existing classes. Start with a documented composite when an extra component is unnecessary; add a component where several elements must share state or sizing behavior.

| Priority | Proposed API | Rails examples and expected benefit |
| --- | --- | --- |
| 1 | Icon-only buttons: `.icon-button`; tokens for square dimensions, padding, icon size and radius | `.collection-trigger`, `.collection-close`, `.cocktail-panel-actions` and `.picker-close` repeat square sizing, centering and hit-area rules. Support both real buttons and links with appropriate button semantics. Preserve a useful tap target even when the glyph is small. Control sizing is already covered by the adopted `.size-*` modifiers in Semanticus 3.3.0; no additional size API is proposed. |
| 2 | Selectable options and chips: `.choice`, `.chip`, `.chip-removable`; theme tokens for selected/hover/focus surfaces and borders | `.library-privacy-option`, `.collection-choice`, `.marketplace-options label`, `.marketplace-chip`, `.personal-state` and `.personal-visibility`. Handle native `:checked`, button `aria-pressed`, focus within, disabled state and removal controls. Keep native radio/checkbox semantics; do not impose listbox semantics on every choice. |
| 3 | Edge dialogs and bounded popovers: `.dialog-drawer-end`, `.popover-panel`; tokens for width, maximum block size, inset and backdrop | `.cocktail-panel`/profile panels duplicate an edge-attached dialog, while `.marketplace-popover` implements anchored desktop positioning and a bounded mobile sheet. Extend the existing dialog styling with variants; document required focus, Escape, dismissal and scroll behavior. CSS alone does not implement those behaviors. |
| 4 | Avatar and media frame: `.avatar` with size tokens; `.media-frame` with configurable native aspect ratio and fit | `.profile-avatar`, `.user-avatar`, `.card-image`, `.recipe-editor-photo`, collection artwork tiles. Include initials fallback, clipping and image fit without requiring the absolute-child layout of the existing `.ratio` component. Keep collage layout and hover transforms application-specific. |
| 5 | Small layout/text utilities: `.min-w-0`, `.min-h-0`, `.place-items-center`, `.place-content-center`, `.text-pre-wrap`, `.text-wrap-anywhere`, `.text-balance`, `.tabular-nums`, `.line-clamp-2` | Repeated in editor fields, card/collection titles, ingredient copy, submitted recipe prose, avatars, numeric controls and descriptions. A two-line clamp is different from the existing single-line `.text-truncate`; preserving whitespace is different from `.text-wrap`. Avoid replacing `overflow-wrap:anywhere` with a different word-breaking algorithm. |
| 6 | Underlined navigation composite and configurable spacing/reading measures | `.primary-navigation`, `.profile-sections`, `.personal-filters` share active-link treatments; use `aria-current` for navigation and reserve tab roles for real tab widgets. Add a spacing escape hatch such as `gap-custom` + `--utility-gap`, plus logical margin/padding counterparts, and configurable reading-width utilities. This avoids mutating global `--spacing` or creating dozens of one-off classes for 32/42/58/72rem page widths. |

For the greatest reduction, implement priorities 1–3 first. They remove repeated groups of declarations and state selectors, whereas individual utilities mostly remove one declaration per use.

Do not add duplicate implementations of flex utilities, grids, visually hidden text, single-line truncation, generic dialogs, cards, panes, or dropdowns: those already exist. The existing dropdown composite may help the account menu, but adopting ARIA menu roles also requires the corresponding keyboard interaction. Keep ordinary navigation links until that behavior is implemented.

Leave branded gradients, the full-bleed photograph treatment, exact responsive composition, collection collages, preparation completion styling and print presentation in ShakeStir. Generalize their underlying primitives only when another application needs them.

## Adopted: Semanticus 3.3.0 size modifiers

Updated `app/assets/stylesheets/semanticus.css`, `vendor/semanticus/LICENSE` and `vendor/semanticus/NOTICE` from the published `@semanticus/semanticus-css@3.3.0` npm tarball. No npm runtime dependency was added. See the [size modifier documentation](https://semanticus.design/docs/variants/modifiers/size).

The framework now provides `.size-sm`, `.size-md` and `.size-lg`. Use those existing APIs instead of introducing the previously proposed `.control-sm` / `.control-md`. `.size-md` explicitly selects normal themed sizing; it does not create a different medium appearance. `.size-sm` sets font and padding through component variables without `!important`.

| Existing control | Adopted modifier | Removed custom sizing | Retained constraints |
| --- | --- | --- | --- |
| Selected ingredient/utensil filter chips (`.marketplace-chip`) | `.size-sm`, including dynamically generated buttons | `.85rem` font and `.3rem .85rem` padding | `2.2rem` minimum height and chip colors/shape |
| Ingredient and step reset buttons (`.checklist-reset`) | `.size-sm` | `.875rem` font and `.5rem` padding | `2.75rem` minimum height, quiet appearance and disabled state |
| Library primary/secondary actions, including Create collection / Save changes | `.size-md` | `.9rem` font and `.7rem 1.2rem` padding | `2.9rem` minimum height, weight, color and radius |
| Signed-in star buttons and signed-out sign-in links (`.recipe-star-button`) | `.size-md` | `.9rem` font and `.6rem .85rem` padding | `2.9rem` minimum height, star states, shape and line height |

These replacements intentionally normalize sizing: compact controls use the framework's `.875rem` font and `.25rem .5rem` padding; regular actions use the existing theme's default `1rem` button font and `.65rem 1.25rem` padding. This update does not claim pixel-identical dimensions. Minimum tap targets remain application constraints.

The 3.3.0 local `.button` link styling consumed `--buttons-font-size` alongside its existing button padding tokens; 3.4.0 supersedes it with the framework implementation. Signed-out star links use that styling; signed-in native star buttons receive the equivalent base styling directly from Semanticus without a redundant `.button` class. Size classes are applied directly to controls; a generic wrapper would not resize its descendants. No extra roles were added to navigation links.

The original recommendation to invent generic `.control-*` classes remains withdrawn. Using an established, supported framework modifier is now the appropriate replacement for these bespoke sizing declarations. Other proposals above remain independent of this size API.

## Initial migration verification

- Rails suite: **239 tests, 2,865 assertions, no failures or errors** after the initial migration; final template changes additionally passed **46 controller tests, 430 assertions**.
- Automated Chromium comparison against the original application CSS: 12 signed-in routes at 1440px and 390px, in screen and print media (**48 comparisons**). Covers discovery, canonical catalog/detail, recipe detail, profile, account, personal recipes/collections, collection detail and both editors. **No element bounding-box differences** at the script's 0.1px precision. One computed automatic margin on the desktop recipe wrapper resolved differently while its position and size remained identical; pixel identity is not asserted.
- Browser interactions at both widths: open availability picker, select an option, check/reset an ingredient, open collection dialog and inspect dynamically generated choices. No recipe/collection save mutations were made.
- Inspected rendered desktop cover and phone picker/dialog captures after transitions settled.
- Impeccable mechanical detector: no findings. `git diff --check`: clean.
- JavaScript tests: five pass; the existing preparation test fails because it expects `statusTarget.hidden` to become false on connect. Neither that test nor the preparation controller was changed by this migration. Its behavior is outside this CSS cleanup.

These checks cover the sampled routes and interactions, not every application state or browser engine. Screenshots and temporary comparison scripts are session QA artifacts under `/tmp/shakestir-semanticus/`, not committed production assets.

## Size modifier upgrade verification

Validation for the 3.3.0 asset update and size adoption is separate from the original geometry-preserving migration:

- Rails: **239 tests, 2,865 assertions, no failures or errors**.
- Relevant JavaScript tests: **4 passed** (marketplace search and recipe stars).
- Chromium at 1440px and 390px: chips resolve to 14px font / 4px 8px padding / 35.2px minimum height; resets to 14px / 4px 8px / 44px; star controls to 16px / 10.4px 20px / 46.4px minimum height.
- Availability selection, ingredient check/reset and collection-dialog interactions pass at both widths. Rendered phone dialog inspected after transitions settled.
- Published CSS, LICENSE and NOTICE match the downloaded 3.3.0 package byte-for-byte.
- Mechanical design detector reports no findings; `git diff --check` is clean.

Temporary captures and browser scripts are under `/tmp/shakestir-size-upgrade/`.

## Native button and navigation-link review

Searched Rails views, helpers and JavaScript-created controls for redundant `.button` classes and button roles. Removed `.button` from the signed-in native star button, the only matching native control. Other `.button` uses are navigation links (sign-in, account creation, recipe/collection creation and editing, profile editing, and empty-state navigation); they keep link semantics and their visual class. Dialog-enhanced author, cocktail and technique links retain real destination URLs as fallbacks. No `role="button"` attributes were introduced to obtain styling.

## Button theme customization through Semanticus variables (3.3.0 migration)

Native controls now use Semanticus's renderer instead of restating its font, padding, radius, foreground, background and hover properties. The theme keeps shared defaults in `--buttons-padding-block` / `--buttons-padding-inline`, and individual components configure:

- `--buttons-background-color` and `--buttons-background-color-hover`;
- `--buttons-color` and `--buttons-color-hover`;
- `--buttons-font-size`, `--buttons-padding-block` and `--buttons-padding-inline`;
- `--border-radius`, `--font-weight` and `--line-height` where supported by the native button styles;
- `--group-buttons-padding-inline` for controls inside the search group, whose contextual padding takes precedence over ordinary button padding.

Converted library actions, recipe stars, checklist resets, collection triggers/choices/close buttons, technique/panel close buttons, personal search, filter chips, picker controls and navigation creation links. Primary library actions inherit primary background/hover defaults rather than redefining those values. Selected collection and picker choices configure the same background slots. No internal `--_buttons-*` properties are overridden.

The 3.3.0 migration retained a `.button` adapter for actual navigation anchors. Semanticus 3.4.0 now provides this class directly; the local adapter has been removed (see the update below). Native buttons do not need this adapter. `.recipe-star-button` remains a component customization/state hook: its token values, icon sizing, pressed state, busy feedback and photo-overlay treatment differ from generic primary actions. Removing the class alone would just move those selectors elsewhere.

Custom borders, minimum tap targets, positioning, SVG fill, busy cursors and focus outlines remain because the current public button API does not expose equivalent dedicated slots for all of them. Replacing declarations with variable assignments improves framework integration; it does not inherently reduce declaration count. Consider proposed new framework components only after using these existing slots.

Verification: 32 relevant Rails tests / 308 assertions pass. Chromium comparison against the immediately preceding styles covered 48 desktop/phone screen/print page combinations with no normal-state geometry or sampled computed-style differences. An additional 56 control-state comparisons retained dimensions; 18 hover/focus comparisons intentionally changed to the component's configured theme rather than the primary-action fallback that previously won the cascade. Picker selection, checklist reset and collection-dialog checks pass at both widths. The mechanical detector reported no findings; whitespace checks pass. Temporary QA files live under `/tmp/shakestir-button-tokens/`.

## Shared near-white secondary actions

The app now themes plain secondary native controls and button-styled navigation anchors together in `theme.css`. The selector is scoped to supported controls plus `a.button`; generic `.secondary` cards, alerts and other components keep their existing framework palettes. It defines local `--secondary-background-color` (`#fffef9`), hover (`#eceee3`), foreground and focus tokens, and maps those to the public `--buttons-*` slots used by button-styled anchors. Quiet borders and the higher-contrast border treatment are configured once. Semanticus's own intent renderer reads the same secondary palette for native controls.

Applied `.secondary` to library secondary actions, personal-library search, signed-in and signed-out star controls, collection triggers, cover back links and panel controls. Replaced `.library-primary` / `.library-secondary` with a shared `.library-action` layout hook plus `.primary` / `.secondary`. Removed repeated component palette definitions and the now-redundant panel-close style block. Primary actions remain olive. Cancel/reset/remove actions retain their quiet or destructive treatments; collection choice rows retain their selection-specific styling.

Photo-overlay star controls override the secondary background tokens locally, retaining their translucent normal surface and solid hover surface. Pressed stars retain olive text/fill on detail pages; image overlays retain their dark foreground for legibility. Navigation anchors keep link semantics.

Validation: **51 Rails tests / 445 assertions pass**. **34 targeted browser assertions** at 1440px and 390px cover secondary normal/hover/focus colors, pressed stars, image-overlay transparency, unaffected generic secondary cards/alerts, contrast mode and horizontal overflow. Existing picker, reset and collection-dialog interactions also pass at both widths. The 48-route/media comparison found no geometry changes; personal-search foreground intentionally changes from olive to the shared dark secondary foreground. Inspected phone profile/detail captures. Mechanical detector and whitespace checks pass. QA artifacts are under `/tmp/shakestir-secondary/`.

## Semanticus 3.4.0: framework `.button` replaces the adapter

Updated the full vendored CSS, LICENSE and NOTICE using the Semanticus 3.4.0 source at commit `70f25c2` (`feat: add button class for anchors and bump to 3.4.0`). At update time npm returned 404 for `@semanticus/semanticus-css@3.4.0`, so the asset was built with `npm run build:full` in the neighboring checkout. The source was clean apart from unrelated untracked screenshot fixtures when built. Later unrelated source/repository edits were not included.

Removed the local `.button` renderer and its hover/focus/active rule from `theme.css`. Existing anchor markup now uses the framework class without adding button roles. Semanticus owns padding, typography, radius, background, border, interaction states and variant integration. Local CSS retains theme variables, minimum tap targets, app motion and contextual layout. Added `d-inline-flex` to cover back links and the navigation Create account link because display layout was previously supplied by the adapter.

The native framework navigation context now supplies the Create account link's padding and border. This produces a slightly narrower action while retaining its minimum height; it is the only normal-state layout change in the comparison. Shared secondary colors, selected star colors and photo-overlay transparency remain intact.

Validation: **59 relevant Rails tests / 484 assertions pass**. Captured **26 signed-in/signed-out desktop/phone page states** before and after the upgrade; differences are limited to the navigation action's native padding/border treatment and the resulting positioning of its siblings. **34 secondary-theme browser checks pass**, including anchor/native hover/focus, pressed stars, photo transparency, unaffected secondary cards/alerts and contrast mode. Inspected phone discovery/profile renders. Mechanical detector and whitespace checks pass. Temporary comparison artifacts are under `/tmp/shakestir-button-340/`.

## Semanticus 3.4.1: independent button radius

Updated the vendored full CSS and notices from Semanticus commit `c0187a7` (`feat: allow independent button border radius`), whose package version is 3.4.1. npm did not expose 3.4.1 at update time, so the stylesheet was built with `npm run build:full`. The upstream source banner still said 3.4.0; only the vendored banner version was corrected to match the package. Framework declarations are otherwise unchanged from that build.

The app now sets `--buttons-border-radius: 3rem` at the root. General `--border-radius` stays `.7rem`. Removed the broad `--border-radius: 3rem` override from button selectors and the redundant navigation/technique-close radius assignments. Circular collection/picker/panel controls, collection choice rows and picker match controls override `--buttons-border-radius` locally. Other fields, panels and non-button links keep their existing radius rules. This uses the public token; no internal radius alias override is needed.

Validation: **59 Rails tests / 484 assertions pass**. The **26 before/after desktop/phone page captures** have no element geometry or sampled computed-style differences. **22 radius checks** verify pill buttons/links, circular controls, rectangular choice rows, picker controls and independent general/input radii. File-selector buttons now also follow the pill button theme through the new framework token. Inspected phone profile rendering. Mechanical detector and whitespace checks pass. QA files are under `/tmp/shakestir-button-341/`.

## Shared typography, radius and breakpoint review (2026-11-10)

Reviewed the current 3.4.1 bundle in its actual load order: Semanticus, theme,
cocktail details, collections, personal recipes, profiles. This section supersedes
older observations above about the application's spacing mismatch: the current
root spacing is 1rem (steps .25, .5, 1, 1.5 and 3rem).

- Ordinary small text now shares `--text-small: .875rem` (previously .8/.85/.875),
  and labels/actions share `--text-label: .9375rem` (previously .9/.9375/.95).
  Card titles share `--text-card-title: 1.375rem` (previously 1.3/1.375).
  Custom section/body sizes reuse verified `--h2`–`--h5-font-size` slots; nearby
  1.1/1.15rem treatments use the existing 1.125rem step. Line heights and heading
  semantics stay contextual. Display clamps, portrait initials, quantity type,
  small count badges and icon glyph sizes remain deliberate exceptions.
- General/field radius is .75rem (previously .7), cards/media use the existing
  `--card-border-radius: 1rem`, including nearby .9/1.2rem treatments. Buttons
  retain the independent 3rem pill token and local circular overrides. Small
  .25/.5rem menu/checklist details and zero-radius edge panels remain intentional.
- Common mobile transitions now use `width < 768px` and roomy controls use
  `width >= 768px`, matching Semanticus md instead of 45/45.001rem. Collections'
  40rem layout joins that transition. Small layouts use `< 576px`; content-grid
  and navigation use complementary `< 1024px` / `>= 1024px`, and wide content
  uses `>= 1280px`. These are intentional threshold changes, not unit conversions.
  No framework build or vendor edits were needed. No JavaScript media conditions
  were found; existing image `sizes` hints describe image selection independently.
- Retained breakpoint exceptions: 25rem compresses the personal-filter labels
  only on very narrow phones; 55rem stacks the generic mixing layout and detail
  references before columns become cramped; 65rem coordinates the portrait,
  reading-column offset and reference-grid composition. These are component
  constraints rather than shared device transitions. The 65rem complement now
  uses `width > 65rem` rather than leaving a .001rem gap.
- Pruned unused navbar-search layout rules (the catalog's accessible label is
  still used), superseded header grid/gap rules, repeated panel spacing and
  profile padding/gaps, footer flex behavior overridden by its grid, and detail
  margin/column rules superseded by the final recipe composition. Existing
  utilities remain in place; this pass primarily consolidates shared tokens.

Browser verification: 18 signed-in routes at 1440, 768 and 390px before and after
(54 page states each), with no page errors or horizontal document overflow.
An additional 72 page/viewport checks cover immediately below, at and above
576, 768, 1024 and 1280px across discovery, recipe detail, both editors, profile
and collections; none overflowed. Inspected desktop detail and phone editor
captures, and captured recipe print and reduced-motion/high-contrast states.
These checks do not establish pixel identity: typography, rounding and transition
widths intentionally changed. Temporary artifacts are under
`/tmp/shakestir-css-review-{before,after}/` and `/tmp/shakestir-review-*`.

Rails suite: **251 tests, 4,084 assertions, five failures, zero errors**. All five
failures are in `DetailPagesTest`, whose HTML assertions still expect
`.cocktail-cover` / `img.cocktail-cover-photo`; the unchanged templates render
`.cocktail-profile-hero` / `img.cocktail-profile-image`. These integration tests
inspect response HTML and do not execute the changed CSS. This styling pass
leaves those template/test mismatches untouched. `git diff --check` passes.
