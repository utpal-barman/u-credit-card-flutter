# u_credit_card

A Flutter widget that renders a realistic, customizable credit-card UI with optional flip animation, balance display, and provider-logo support.

[![pub package](https://img.shields.io/pub/v/u_credit_card.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/u_credit_card)
[![Last Commits](https://img.shields.io/github/last-commit/utpal-barman/u-credit-card-flutter?logo=git&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/utpal-barman/u-credit-card-flutter?logo=github&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/utpal-barman/u-credit-card-flutter?logo=github&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter)
[![License](https://img.shields.io/github/license/utpal-barman/u-credit-card-flutter?logo=open-source-initiative&logoColor=green)](https://github.com/utpal-barman/u-credit-card-flutter/blob/main/LICENSE)

<p align="center">
<img src="https://user-images.githubusercontent.com/16848599/233195178-b4fb8007-ba2e-48ed-8020-7a0854d5038c.png" width="700" alt="u_credit_card preview"/>
</p>

## Contents

- [Features](#features)
- [What it is / What it isn't](#what-it-is--what-it-isnt)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Recipes](#recipes)
  - [Custom gradient](#custom-gradient)
  - [Sizing the card](#sizing-the-card)
  - [Card type and network logo](#card-type-and-network-logo)
  - [Provider logo and background image](#provider-logo-and-background-image)
  - [Balance display](#balance-display)
  - [Flipping the card](#flipping-the-card)
- [Programmatic flipping API](#programmatic-flipping-api)
- [Parameters reference](#parameters-reference)
- [Migration notes](#migration-notes)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Realistic card UI** with chip, NFC indicator, gradient background, and OCR-A font for card numbers.
- **Automatic network detection** for Visa, Mastercard, American Express, and Discover from the card number; can also be set explicitly or hidden.
- **Card types** — credit, debit, prepaid, gift card, or none.
- **Flippable card** — horizontal drag gesture flips between front and CVV-bearing back side; optional programmatic control via `CreditCardController`.
- **Balance display** with optional "tap to reveal" mode (auto-hides after 2 seconds).
- **Customizable** gradient colors, provider logo (any `Widget`), provider logo position, background image, card width, and card-number masking.
- **No third-party dependencies** at runtime.

## What it is / What it isn't

| It is | It isn't |
|---|---|
| A presentation-layer widget for displaying card details | A card-number or CVV validator |
| Useful for wallets, dashboards, fintech mockups | A payment-processing or tokenization library |
| Pure Dart + Flutter, no platform channels | A PCI-compliant input form |

If you need card-input form fields or Luhn validation as part of a payment flow, pair this widget with a dedicated forms or payments package.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  u_credit_card: ^1.6.0
```

Then fetch it:

```sh
flutter pub get
```

Import it where you need it:

```dart
import 'package:u_credit_card/u_credit_card.dart';
```

## Quick start

The widget needs three values: cardholder name, card number, and the "Valid Thru" date.

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
)
```

<img width="432" alt="u_credit_card_basic_setup" src="https://user-images.githubusercontent.com/16848599/232335773-5e6fdd6e-a4d9-4c01-a202-48cbca935cbe.png">

By default, the card is purple, shows the NFC icon next to the chip, and masks the middle digits of the card number.

## Recipes

Each recipe builds on the quick-start example and shows only the parameters that change.

### Custom gradient

Set `topLeftColor` and `bottomRightColor` to control the gradient. If you omit `bottomRightColor`, a darker shade of `topLeftColor` is used automatically.

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  topLeftColor: Colors.red,
  bottomRightColor: Colors.purpleAccent,
)
```

<img width="432" alt="u_credit_card_gradient" src="https://user-images.githubusercontent.com/16848599/232333158-e0a3f488-cb36-4142-91a7-12d7d9546fca.png">

Because card text is rendered in white, avoid light gradient colors.

### Sizing the card

Use the `width` parameter rather than wrapping the widget in a `SizedBox`. The card is laid out at its natural width of 300 logical pixels and scales proportionally to fit `width`. Values above 300 are clamped.

```dart
CreditCardUi(
  width: 240,
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
)
```

### Card type and network logo

`cardType` controls the small label at the top of the card (CREDIT, DEBIT, PREPAID, GIFT CARD); pass `CardType.other` to hide the label.

`creditCardType` controls the network logo (Visa, Mastercard, Amex, Discover). If omitted, the widget auto-detects the network from `cardNumber`. Pass `CreditCardType.none` to hide the logo entirely.

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '4111111111111111',  // detected as Visa
  validThru: '10/24',
  cardType: CardType.debit,
  // creditCardType: CreditCardType.mastercard, // optional override
)
```

### Provider logo and background image

`cardProviderLogo` accepts any widget — typically your bank or wallet logo. Position it on the left or right of the card-type label with `cardProviderLogoPosition`. Add a background image with `backgroundDecorationImage`; both `NetworkImage` and `AssetImage` are supported.

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  cardProviderLogo: const FlutterLogo(),
  cardProviderLogoPosition: CardProviderLogoPosition.right,
  backgroundDecorationImage: const DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage('https://example.com/card-bg.png'),
  ),
)
```

<img width="432" alt="u_credit_card_custom" src="https://user-images.githubusercontent.com/16848599/233195568-5a197e2b-115c-46b1-876c-3428726f38cb.png">

### Balance display

Set `showBalance: true` and pass a `balance` to render the amount in the top-left of the card. Enabling `autoHideBalance: true` replaces the figure with a "TAP TO SEE BALANCE" placeholder; tapping reveals it for two seconds. `currencySymbol` defaults to `$`.

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  showBalance: true,
  balance: 128.32,
  autoHideBalance: true,
  currencySymbol: '€',
)
```

### Flipping the card

Set `enableFlipping: true` to render a back side (with the CVV) and enable a horizontal-drag gesture that flips between sides. Provide the CVV with `cvvNumber`.

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  enableFlipping: true,
  cvvNumber: '123',
)
```

<img src="https://github.com/utpal-barman/u-credit-card-flutter/assets/16848599/350654f2-30c1-464b-93f2-7ed721f07792" width="432" alt="u_credit_card flipping animation"/>

Haptic feedback fires on each flip; disable it with `disableHapticFeedBack: true`.

## Programmatic flipping API

For flows that need to flip the card in response to UI events — for example, flipping to the back when a CVV input field gains focus — attach a `CreditCardController`.

```dart
class CheckoutCard extends StatefulWidget {
  const CheckoutCard({super.key});

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  final _cardController = CreditCardController();
  final _cvvFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cvvFocusNode.addListener(() {
      if (_cvvFocusNode.hasFocus) {
        _cardController.flipToBack();
      } else {
        _cardController.flipToFront();
      }
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardUi(
          controller: _cardController,
          enableFlipping: true,
          cardHolderFullName: 'John Doe',
          cardNumber: '1234567812345678',
          validThru: '10/24',
          cvvNumber: '123',
        ),
        TextField(
          focusNode: _cvvFocusNode,
          decoration: const InputDecoration(labelText: 'CVV'),
        ),
        ElevatedButton(
          onPressed: _cardController.flipCard,
          child: const Text('Flip'),
        ),
      ],
    );
  }
}
```

`CreditCardController` exposes:

| Member | Description |
|---|---|
| `flipCard()` | Toggles between front and back. |
| `flipToFront()` | Flips to the front; no-op if already on the front. |
| `flipToBack()` | Flips to the back; no-op if already on the back. |
| `isFlipped` | Getter — `true` when the back side is showing. |

`CreditCardController` extends `ChangeNotifier`, so you can `addListener` to react to flip state changes. Call `dispose()` from your widget's `dispose` method.

The controller has no effect when `enableFlipping: false`. Pair the two parameters together.

## Parameters reference

Listed alphabetically. Defaults reflect the constructor; `null` means "not provided".

| Name | Type | Default | Description |
|---|---|---|---|
| `autoHideBalance` | `bool?` | `false` | Shows a "TAP TO SEE BALANCE" placeholder; tapping reveals the balance for 2 seconds. |
| `backgroundDecorationImage` | `DecorationImage?` | `null` | Image painted under the gradient. Supports `NetworkImage` and `AssetImage`. |
| `balance` | `double?` | `0.0` | Balance displayed when `showBalance` is `true`. |
| `bottomRightColor` | `Color?` | derived | Bottom-right gradient stop. Defaults to a darker shade of `topLeftColor`. |
| `cardHolderFullName` | `String` | **required** | Rendered uppercased on the front of the card. |
| `cardNumber` | `String` | **required** | The card number. Spaces, dashes, and asterisks are normalized before display. |
| `cardProviderLogo` | `Widget?` | `null` | Any widget — typically a bank or brand logo. |
| `cardProviderLogoPosition` | `CardProviderLogoPosition` | `.right` | Position of `cardProviderLogo` relative to the card-type label. |
| `cardType` | `CardType` | `.credit` | Drives the small label at the top of the card. `CardType.other` hides the label. |
| `controller` | `CreditCardController?` | `null` | Drives programmatic flipping. Requires `enableFlipping: true`. |
| `creditCardType` | `CreditCardType?` | `null` | Overrides the auto-detected network logo. Pass `.none` to hide it. |
| `currencySymbol` | `String?` | `'$'` | Prefix shown before the balance. |
| `cvvNumber` | `String?` | `'***'` | Shown on the back of the card when flipped. |
| `disableHapticFeedBack` | `bool?` | `false` | Disables haptic feedback on flip and balance tap. *(Note: the capital "B" reflects the existing public API.)* |
| `doesSupportNfc` | `bool` | `true` | Shows the NFC icon next to the chip. |
| `enableFlipping` | `bool?` | `false` | Renders the back side and enables the drag-to-flip gesture. Required for `controller` to take effect. |
| `placeNfcIconAtTheEnd` | `bool` | `false` | Moves the NFC icon to the opposite side of the chip. Has no effect when `doesSupportNfc: false`. |
| `scale` | `double` | `1.0` | **Deprecated** — use `width` instead. Will be removed in a future minor release. |
| `shouldMaskCardNumber` | `bool` | `true` | Masks the middle digits with `*`. Card numbers under 12 digits are never masked. |
| `showBalance` | `bool?` | `false` | Shows the balance area in place of the card-type label. |
| `showValidFrom` | `bool` | `true` | Shows the "VALID FROM" segment when `validFrom` is provided. |
| `showValidThru` | `bool` | `true` | Shows the "VALID THRU" segment. |
| `topLeftColor` | `Color` | `Colors.purple` | Top-left gradient stop. |
| `validFrom` | `String?` | `null` | Optional "MM/YY" start date. |
| `validThru` | `String` | **required** | "MM/YY" expiration date. |
| `width` | `double?` | `null` | Maximum width in logical pixels. Capped at 300; smaller values scale the card proportionally. |

Full API documentation is available on [pub.dev](https://pub.dev/documentation/u_credit_card/latest/u_credit_card/CreditCardUi-class.html).

## Migration notes

- **`scale` → `width`** (since 1.3.0). `scale: 0.8` is equivalent to `width: 240`. The `scale` parameter will be removed in a future minor release.
- **`disableShowingCardLogo` removed** (since 1.1.0). Use `creditCardType: CreditCardType.none` instead.
- **`CreditCardController`** added in 1.6.0 for programmatic flipping. Existing widgets using only the drag gesture need no changes.

## Compatibility

- **Flutter**: 3.x (uses APIs available from Flutter 3.16+, e.g. `Durations`).
- **Dart**: `>=3.3.0 <4.0.0`.
- **Platforms**: any platform Flutter supports — no platform channels involved.

## Contributing

Bug reports, feature requests, and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).

For security-sensitive reports, follow the guidance in [SECURITY.md](SECURITY.md).

## License

Released under the [BSD 3-Clause License](LICENSE).

---

<p align="center">
  <a href="https://www.linkedin.com/in/utpal-barman/">
    <img src="https://user-images.githubusercontent.com/16848599/232288339-ecbd6cb1-3210-4304-b1e1-bc8434e290a8.png" width="100px" alt="Utpal Barman" style="border-radius:50%"/>
  </a>
  <br/>
  <b>Utpal Barman</b>
  <br/>
  <sub>Built with ♥ in Bangladesh — ধন্যবাদ</sub>
  <br/><br/>
  <a href="https://www.linkedin.com/in/utpal-barman/">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
</p>
