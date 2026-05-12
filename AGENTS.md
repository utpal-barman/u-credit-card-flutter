# AGENTS.md

Guidance for any AI coding agent working in this repository.

## What this is

`u_credit_card` is a single-widget Flutter package on pub.dev rendering a credit/debit card UI with optional flip animation, balance display, NFC indicator, masked number, and auto card-network detection. `lib/` ships the package; `example/` is a runnable demo. Dart SDK constraint and lint package pinned in `pubspec.yaml`; lints via `very_good_analysis`.

## Public API

`lib/u_credit_card.dart` exports exactly two classes + their enums: `CreditCardUi` (the `StatelessWidget`) and `CreditCardController` (`ChangeNotifier` for programmatic flipping). Enums: `CardType`, `CreditCardType`, `CardProviderLogoPosition`. Everything in `lib/src/` is private — do not import `src/...` externally or add exports without strong reason.

## Architecture (the non-obvious bits)

- **Fixed 300×190 design** (aspect 1.5789). Sub-widgets in `lib/src/ui/` are placed via `Positioned` with hard-coded offsets calibrated to this size. The `width` prop scales via `Transform.scale` (capped at 300, only scales down). README warns consumers not to wrap with `SizedBox` — use `width:` instead.
- **Flip animation** (`AnimatedFlippingCard`, private, in `lib/src/u_credit_card.dart`) owns the only `AnimationController`. Renders via `Matrix4` perspective + `rotateY` + 0.8→1.0 zoom-out, with `AnimatedSwitcher` swapping front/back at `value >= 0.5`. Horizontal-drag gesture triggers flip with `HapticFeedback.mediumImpact` (unless `disableHapticFeedBack`).
- **Controller bridge** (`CreditCardController`): controller is stateless about animation. `AnimatedFlippingCard.initState` calls `setFlipCallback(_flip)` and attaches an animation listener that calls `setFlipState(isFlipped: …)`. `didUpdateWidget` swaps callbacks across controller instances; `dispose` clears the callback on the old controller. Preserve this lifecycle — losing the clear-on-dispose path causes stale-callback crashes.
- **Card-network detection** (`lib/src/utils/utils.dart`): `CreditCard` runs a mod-10 checksum + prefix matching (`4*`→Visa, `5[1-5]*`→Mastercard, `34/37*`→Amex, `6011*`/`65xx*`→Discover). `CreditCardHelper.getCardLogoFromCardNumber` consumes it; explicit `creditCardType` overrides via `getCardLogoFromType`; `CreditCardType.none` suppresses the logo.
- **Bundled assets**: `assets/images/` and `fonts/OCR-A-regular.ttf` are declared in `pubspec.yaml` and loaded with `Image.asset(path, package: UiConstants.packageName)` so consumers don't redeclare them.

## Commands

```sh
flutter pub get
flutter analyze lib test                          # CI gates on this
flutter test                                      # all tests
flutter test test/src/credit_card_controller_test.dart   # single file
flutter test --name "flipCard calls the registered callback"
dart format --line-length 80 --set-exit-if-changed lib test
cd example && flutter run
```

CI (`.github/workflows/main.yml`) gates on semantic PR title, markdown spell-check, the format check, and `flutter analyze`. `publish.yml` publishes to pub.dev on a `v*` tag pushed to `main` (OIDC).

## Conventions

- **Conventional Commits, always.** Every commit message and PR title leads with `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `perf:`, `build:`, or `ci:`. Branches use `feat/...`, `fix/...` (see `CONTRIBUTING.md`).
- **Never add AI/Claude attribution** to commits or PRs — no `Co-Authored-By: Claude …`, no "Generated with Claude Code" footer.
- **Version bumps update two places together**: `pubspec.yaml` `version:` AND `README.md` (line 1 header and the install snippet). Drift here is the most common pre-publish bug.
- Add new test files for new features rather than appending to existing ones.
- Update `CHANGELOG.md` by hand on release.
