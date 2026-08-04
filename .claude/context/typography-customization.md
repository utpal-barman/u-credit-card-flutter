# Typography customization

Letting consumers supply their own text styles for the card's text slots.

**Status: planned, not implemented.** Plan drafted and paused before review; nothing posted to the tracker, no branch, no code.

## What exists now

Nothing configurable. All ten text slots hard-code colour, size, weight, and letter spacing. A consumer cannot change even the text colour — which matters, because the card renders white text and the README already warns against light gradient colours for that reason.

`lib/src/ui/credit_card_text.dart` is the shared text widget for four slots. It hard-codes exactly what a caller would most want to change (`color: Colors.white`, `fontFamily: UiConstants.fontFamily`, `package:`) and exposes only `letterSpacing`, `fontSize`, `fontWeight` — all internal, since `lib/src/` is private and `lib/u_credit_card.dart` exports only `src/u_credit_card.dart` and `src/controller/credit_card_controller.dart`.

### The ten text slots

Verified by reading each site.

| # | Slot | Location | Current style |
|---|---|---|---|
| 1 | Card number | `u_credit_card.dart:369` | `CreditCardText` defaults: ls 3.2, fs 16, w700 |
| 2 | Card holder name | `credit_card_holder_name_view.dart:19` | ls 2, fs 12, uppercased, inside `SizedBox(width: 172)` |
| 3 | Valid-from value | `credit_card_validity_view.dart:58` | ls 2, fs 9 |
| 4 | Valid-thru value | `credit_card_validity_view.dart:83` | ls 2, fs 9 |
| 5 | "VALID FROM" label | `credit_card_validity_view.dart:45` | fs 5, height 1.2, `ARGB(255,200,200,200)`, inside `SizedBox(width: 24)` |
| 6 | "VALID THRU" label | `credit_card_validity_view.dart:73` | same as #5 |
| 7 | Card type title | `credit_card_top_section_view.dart:82` | `white70`, fs 8, ls 1.5 |
| 8 | Balance | `credit_card_top_section_view.dart:150` | white, fs 14, bold, inside `SizedBox(width: 100)` |
| 9 | "TAP TO SEE BALANCE" | `credit_card_top_section_view.dart:172` | `black54`, fs 8, bold |
| 10 | CVV (back side) | `u_credit_card.dart:424` | **no style at all** — inherits `DefaultTextStyle` |

Slots 1–4 route through `CreditCardText`; 5–10 are inline `Text` widgets. Slot 10 is a pre-existing inconsistency: the CVV is the only text that neither uses OCR-A nor sets a colour.

## The plan

Merge semantics, not replacement: each slot's package default is the base, and a caller-supplied `TextStyle` merges on top via `base.merge(userStyle)`. Overriding only `color` therefore keeps OCR-A and the letter spacing, and a `null` style leaves every existing consumer pixel-identical.

| File | Change |
|---|---|
| `lib/src/models/credit_card_text_styles.dart` (new) | Immutable `CreditCardTextStyles` with one nullable `TextStyle` per slot — `cardNumber`, `cardHolderName`, `validityValue`, `validityLabel`, `cardTypeTitle`, `balance`, `tapToSeeBalance`, `cvv` — plus `copyWith`, `==`/`hashCode`. Slots 3–6 share `validityValue`/`validityLabel` rather than getting four fields; a per-side split has no plausible use. |
| `lib/u_credit_card.dart` | Export the new file. |
| `lib/src/u_credit_card.dart` | One new parameter `this.textStyles = const CreditCardTextStyles()`, threaded to `CreditCardText`, `CreditCardHolderNameView`, `CreditCardValidityView`, `CreditCardTopLogo`, and the CVV `Text`. |
| `lib/src/ui/credit_card_text.dart` | Add `TextStyle? style`; build the current style as the base and return `base.merge(style)`. Keep `maxLines: 1` and `overflow: TextOverflow.clip`. |
| The three view files | Accept and apply their slots. Slots 5, 6 and 9 lose `const` where a style is injected. |

**Public API impact:** additive — one optional parameter with a default, one new exported class. No existing signature changes. Semver **minor**.

**Tests:** new file `test/src/credit_card_text_styles_test.dart` (this repo prefers new files over appending) — defaults unchanged at every slot; merge-not-replace (supplying only `color` on `cardNumber` keeps `fontFamily: 'ocr-a'`, `package: 'u_credit_card'`, ls 3.2, fs 16, w700); each slot reaches its intended widget and no other; `copyWith` and value equality; `validityLabel` affects both labels.

**Docs:** dartdoc on the class and every field (`very_good_analysis` requires public-API docs, and coverage feeds pub points); a README styling section noting that sizes are calibrated for the fixed 300×190 design. No CHANGELOG or version edit — that belongs to the release flow.

## Decisions

- **Merge, not replace.** Replacement would silently drop the packaged OCR-A font whenever a caller set a single property, and would make the change non-additive in practice.
- **Text only.** The maintainer's stated ambition is "all styling customization" — colours, radii, spacing. Widening this slice to cover that would make the diff too large to review; those get their own slices.
- **No auto-fitting.** Slots 2, 5, 6 and 8 sit inside fixed `SizedBox`es (172, 24, 24, 100) and `CreditCardText` clips at one line, so a large `fontSize` clips rather than reflows. Auto-shrinking or clamping would fight the calibrated-offset invariant in `AGENTS.md`. Document the constraint instead.

## Open questions

1. **One grouped parameter vs. eight flat ones.** This plan proposes a single `textStyles` object. Flutter's own convention for multi-slot widgets is flat parameters (`ListTile.titleTextStyle`, `subtitleTextStyle`, `leadingAndTrailingTextStyle`) — more discoverable in autocomplete, stays `const`-friendly. The grouped object wins on constructor size: `CreditCardUi` already takes 24 parameters, and "all styling customization" implies more coming, which a container absorbs without further churn. **This is the main call to settle before implementing — reversing it later is breaking.**
2. **CVV default (slot 10).** Giving the CVV an explicit default style is a *visual* change for existing users, not purely additive. The plan keeps its inherited appearance and only applies a style when the caller supplies one. Fixing the inconsistency deserves its own slice.

## What's inferred, not verified

The reporter's issue body is empty — the request is a title plus a maintainer comment promising broad styling customization. That per-slot control (rather than one style for the whole card) is what's wanted is a reading of intent, not a stated requirement. Worth confirming with the reporter before building.

## Out of scope

Colour/radius/gradient/spacing customization; theme inheritance from `Theme.of(context).textTheme` (changes default appearance, so not additive); per-side validity split; the CVV default fix; auto-fitting text to the fixed card size.
