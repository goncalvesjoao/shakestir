# CSS consolidation and spacing review

Reviewed 2026-11-10. Scope: the Rails website currently served on port 3000,
including its vendored Semanticus 3.4.1 integration. The separate React client
and the upstream Semanticus project are unchanged.

## Current: simplify around Semanticus's native scale

A further review approximated ordinary spacing using the native scale.
**Eleven numbered `--space-*` exceptions** remain for exact composition
requirements, so their use is visible and can inform future Semanticus additions.
Ordinary component spacing now uses `--spacing-1` through `--spacing-5` directly:
**4 / 8 / 16 / 24 / 48px**, with `--spacing: 1rem` as the single configuration.
This pass intentionally changes spacing; it is not an alias-only refactor.

Decisions were made by purpose:

- Metadata, label gaps and short heading margins generally use 8px.
- Input horizontal padding, notes and field groups use 16px; compact buttons
  use 8px vertically and 16px horizontally.
- Cards, list/grid gaps, form sections and compact form padding use 24px.
- Major section spacing and roomy desktop editor padding use 48px. Form and
  dialog padding now uses compact/roomy breakpoint steps rather than a fluid
  continuum of intermediate values.

154 ordinary references were normalized, while 19 uses involving geometry
preserve their distances through the tracked exception tokens. These include the
approved 72px wide-screen portrait overlap, its 32px default overlap, phone
artwork clearance, fixed viewport gutters and sticky-header scroll clearance.
The profile's mobile action indentation now follows its actual avatar/icon
width plus the selected gap, rather than an independent numbered distance.

### Exact distances retained for review

The 2026-11-13 orphan sweep removed tokens whose portrait and scroll-clearance
consumers no longer exist. Only the current content-gutter exceptions remain below.

The number in `--space-N` counts `--spacing-1` units (4px), not Semanticus's
utility index. Definitions live together in `theme.css`.

| Token | Default size | Current purpose |
| --- | --- | --- |
| `--space-16` | 64px | Desktop content gutter |
| `--space-32` | 128px | Large-desktop content gutter |

This follow-up names the retained calculations without changing their values.
Structural relationships, such as profile action indentation following the
avatar/icon width plus its native gap, remain expressed as relationships.

Eleven component spacing declarations moved to Semanticus utilities across
14 templates. Examples include `gap-2` for section labels and privacy options,
`gap-3` for recipe field groups, `row-gap-2 column-gap-3` for metadata, `p-3` for
editor notes, `mb-4` for form groups/back links, and `mt-2` for photo removal.
Responsive spacing stays in CSS when a utility's `!important` would obstruct
an intended breakpoint change.

Nearby native values were preferred over reproducing every intermediate gap
by combining parent padding and child margin. Such a split changes box sizes,
background/border placement and margin-collapse behavior; it is useful only
when each side has a clear structural purpose. This pass required no extra
wrappers or artificial parent/child spacing compensation.

Verification: 54 authenticated page/viewport combinations (18 routes at 1440,
768 and 390px), reviewed screenshots, no page errors or horizontal overflow.
Panel controls/top inset, asynchronous collection choices, preparation reset,
technique choice labels and recipe print checks pass at all three widths.
55 relevant Rails tests / 534 assertions pass. Custom CSS now has 1,694
declarations versus 1,719 immediately before this pass. The vendor file and
its utility definitions remain unchanged.

### Utility follow-up

A further pass moved invariant border, margin, padding, gap and flex layout
responsibilities to existing Semanticus utilities across 16 templates. Examples
include `border-top pt-2` for personal recipe actions, `border-bottom pb-4 mb-4`
for editor sections, `border-top pt-4 mt-3` for editor actions, `border-0 mt-0
mx-0` for form groups, and `p-1 gap-1` for the status-filter container. Personal
card copy uses a conditional `pb-3` in the shared recipe partial.

The reported `.personal-recipe .card-meta` reset was obsolete: no template
renders a `.card-meta` element. It and its two unused base-style blocks were
removed rather than adding classes to nonexistent markup. Classes such as
`.personal-toolbar` retain responsive gaps. The privacy icon keeps its display
rules in CSS because its phone breakpoint hides it; an unconditional `d-flex`
utility would defeat that behavior.

Before/after Chromium comparisons across 54 route/width combinations found
identical element geometry, display, spacing, borders, alignment and image fit.
Screenshots were reviewed; 55 relevant Rails tests / 534 assertions pass.
Panel, collection-dialog, preparation, native-scale and print interaction
checks also passed during this utility migration.

The toolbar now uses `gap-3 gap-md-4`, deliberately aligning its gap change
with Semanticus's 768px breakpoint (previously 720px). Ingredient rows use
`row-gap-1 column-gap-3`, replacing the layered gap declarations. The tools
section's old bottom margin and heading rule were superseded by reference-grid
rules and were removed without introducing an overriding utility. Follow-up
checks retained identical computed styles at the 54 sampled page/width pairs;
720px, 721px, 767px and 768px were also checked around the toolbar transition.
39 targeted controller tests / 327 assertions pass.

The following sections record the earlier migrations and their measurements.

## Earlier spacing migration

`theme.css` configures Semanticus's `--spacing: 1rem`. Its derived
`--spacing-1` is the shared 4px unit at the default root size. Use the framework's
`--spacing-1` through `--spacing-5` wherever a size matches. Custom `--space-N`
tokens remain only for sizes outside that scale, derived from `--spacing-1`;
for example, `--space-3` is 12px. Rem units preserve font-size and zoom preferences.

Semanticus is configured through its public variables, without modifying the
vendored stylesheet. `--spacing` is now `1rem`, replacing the
framework's responsive `.75rem * --_spacing-scale` default. This also prevents
framework breakpoint scaling from moving utilities off the shared grid.

| Semanticus utility suffix | Shared token | Default size |
| --- | --- | --- |
| `-1` | `--spacing-1` | 4px |
| `-2` | `--spacing-2` | 8px |
| `-3` / `-d` | `--spacing-3` | 16px |
| `-4` | `--spacing-4` | 24px |
| `-5` | `--spacing-5` | 48px |

These mappings apply to the existing `gap-*`, `m-*`, `p-*` and axis utilities.
**The utility number is the framework's scale index, not a unit count.** Use
`gap-3` for 16px; use `gap: var(--space-3)` for 12px.

Application margins, padding, gaps, scroll spacing and positioned insets now
consume the shared tokens. A follow-up replaced 272 references with native
Semanticus variables and removed six redundant token definitions, including
the separate base-unit alias. Eighteen Chromium page/width comparisons
confirmed identical element geometry and computed spacing before and after
this substitution. Small values were rounded to the nearest positive
unit: `.3rem` becomes `.25rem`, `.6rem` becomes `.5rem`, `.85rem` becomes
`.75rem`, and `.875rem` becomes `1rem`. Existing larger values already on the
grid retain their size. Fluid form/card padding and library gaps use CSS
`round(nearest, clamp(...), var(--spacing-1))` to stay fluid on the same grid.
Search icon clearance also rounds to the grid when a field uses smaller type.

Semanticus input, button, label, navigation, large-size, menu, inline-code,
highlight and icon-link spacing is normalized in the theme. Local form
`--spacing` overrides were removed so utility classes have the same meaning
inside and outside forms. Ordinary button padding is 12px vertically / 20px
horizontally; navigation controls use compact 8px / 12px input padding.

### What is not spacing rhythm

- Font sizes, line heights, tracking, radii, artwork dimensions and shadows keep
  their own scales. They were not rounded as a side effect of this review.
- Automatic centering and percentage/column-alignment calculations remain
  geometric. A computed auto margin can be fractional even though every gap
  used to calculate the columns is a shared token.
- Semanticus's visually hidden `-1px` margins, native file-input focus offsets,
  joined-control border compensation and checkbox optical baseline corrections
  remain technical adjustments, not layout tokens.
- Portrait overlap is now one `--portrait-overlap` variable: 32px normally,
  the approved 72px (`4.5rem`) on wide screens, and 192px for the centered phone
  composition. Height caps reuse the same variable, preserving the panel's
  24px top inset and preventing artwork from escaping above the cover.

## Redundancies removed

Custom CSS fell from **2,479 to 1,725 declarations** (754 fewer, **30.4%**),
and from **101,790 to 76,102 bytes** (25,688 fewer, **25.2%**). Counts exclude
the unchanged vendor stylesheet and empty application manifest; they include
new spacing tokens. Transfer compression and HTML bytes were not measured.

Removed 269 selector branches associated with replaced markup, plus remaining
obsolete picker-only branches when retiring `marketplace.css`. The two live
rules from that file now sit with catalog styles in `theme.css`. Examples of
removed generations include `detail-hero`, `cocktail-breadcrumb`,
`cocktail-cover-photo`, `cocktail-identity-*`, the old marketplace availability
picker, and unused editor rows. Reference checks included templates, helpers
and JavaScript. Dynamically generated catalog/profile classes and Rails's
`field_with_errors` were explicitly retained.

Removed 20 superseded declarations with identical selectors and conditional
contexts. Consolidated the portrait's formerly stacked top/bottom/height
patches into its base rule and breakpoint variables. Shared recipe portrait
rules now inherit the common composition instead of restating it.

Migrated invariant layout to Semanticus across 20 templates: flex/grid display,
alignment, wrapping and matching gap utilities on recipe attribution/actions,
collection dialog headings, library actions, personal recipe badges, profile
sections and the footer. Technique choice labels also use Semanticus flex/gap
utilities so the editor's generic block-label rule cannot suppress their gap.
Component classes remain useful styling/state hooks; deleting their names
would not remove the product-specific CSS they still need.

### CSS intentionally retained

Unequal columns, artwork containment, cover treatments, reading measures,
responsive composition, hidden/print states, selectable states, typography and
brand surfaces remain application responsibilities. Utilities use `!important`,
so responsive or contextual spacing remains in component CSS when a utility
would prevent the intended override. No approximation of an existing
Semanticus component was introduced merely to reduce the number of classes.

## Verification

- Chromium: 18 routes at 1440px, 768px and 390px, before and after (**54 page /
  width combinations** per pass), covering catalogs, every detail type, account,
  profile, recipe/collection libraries and editors. No page errors or horizontal
  overflow. Rendered headings and representative screenshots were reviewed.
- Computed padding, vertical margins and gaps were checked across the same
  routes. Native file-input focus compensation and visually hidden margins
  were separated from rhythm spacing; automatic/column margins remain geometric.
- Semanticus utility gaps resolve to **4 / 8 / 16 / 24 / 48px** at 390px, 768px,
  1440px and 1920px.
- Detail panel opening/closing, portrait top inset, asynchronously populated
  collection dialog, preparation completion/reset and technique-label layout
  passed at desktop, tablet and phone widths. Recipe print hides photography
  and site navigation.
- New CSS spacing tests: **3 pass**. They guard integer token definitions,
  defined token references and the absence of untracked literal spacing.
- Relevant Rails controller tests: **55 tests, 534 assertions, no failures**.
- Full Rails suite: **251 tests, 4,084 assertions, 5 failures**. All five expect
  retired `.cocktail-cover` / `.cocktail-cover-photo` markup, already absent
  before this change. No application/controller behavior was changed to satisfy
  those stale expectations.
- Existing JavaScript suite: two unrelated failures remain: a test imports the
  removed `marketplace_search_controller.js`, and preparation's test expects
  its deliberately hidden status target to become visible. The new spacing
  tests and existing recipe-star tests pass.
- Impeccable detector: 108 advisory findings in existing typography, color and
  radius values; no non-advisory findings. Those separate design scales were
  retained rather than changed during spacing cleanup. `git diff --check` clean.
