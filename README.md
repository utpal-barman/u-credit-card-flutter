# 💳 u_credit_card: ^1.5.0

## Credit Card UI as Flutter Widget 💎

[![pub package](https://img.shields.io/pub/v/u_credit_card.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/u_credit_card)
[![Last Commits](https://img.shields.io/github/last-commit/utpal-barman/u-credit-card-flutter?logo=git&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/utpal-barman/u-credit-card-flutter?logo=github&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/utpal-barman/u-credit-card-flutter?logo=github&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter)
[![License](https://img.shields.io/github/license/utpal-barman/u-credit-card-flutter?logo=open-source-initiative&logoColor=green)](https://github.com/utpal-barman/u-credit-card-flutter/blob/main/LICENSE)

🔥 **u_credit_card** is a Flutter package for creating customizable and realistic-looking credit card UI with engaging animations. Elevate the visual appeal of your app and improve user interaction effortlessly!

<p align="center">
<img src="https://user-images.githubusercontent.com/16848599/233195178-b4fb8007-ba2e-48ed-8020-7a0854d5038c.png" width="700"/>
</p>

## Resources 📚

- [Documentation](https://pub.dev/documentation/u_credit_card/latest/u_credit_card/CreditCardUi-class.html)
- [Pub Package](https://pub.dev/packages/u_credit_card)
- [GitHub Repository](https://github.com/utpal-barman/u-credit-card-flutter)

## Installation 💻

1. **Add** `u_credit_card` to your `pubspec.yaml`:

   ```yaml
   dependencies:
     u_credit_card: ^1.5.0
   ```

2. **Install** the package:

   ```sh
   flutter packages get
   ```

## Usage

To use the `CreditCardUi()` widget, import the package:

```dart
import 'package:u_credit_card/u_credit_card.dart';
```

Create a `CreditCardUi(...)` widget with the required parameters:

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
),
```

<img width="432" alt="u_credit_card_basic_setup" src="https://user-images.githubusercontent.com/16848599/232335773-5e6fdd6e-a4d9-4c01-a202-48cbca935cbe.png">

---

## Parameters

| Name                        | Type                       | Description                                                                                                         |
|-----------------------------|----------------------------|---------------------------------------------------------------------------------------------------------------------|
| `cardHolderFullName`        | `String`                   | The cardholder's full name. **Required**.                                                                           |
| `cardNumber`                | `String`                   | The full credit card number. **Required**.                                                                          |
| `validThru`                 | `String`                   | The expiration date in "MM/YY" format. **Required**.                                                                |
| `validFrom`                 | `String`                   | The "Valid From" date in "MM/YY" format. Optional.                                                                  |
| `topLeftColor`              | `Color`                    | Top-left gradient color. Defaults to `Colors.purple`.                                                               |
| `bottomRightColor`          | `Color`                    | Bottom-right gradient color. Defaults to a darker shade of `topLeftColor`.                                          |
| `doesSupportNfc`            | `bool`                     | Displays NFC icon if set to `true`. Defaults to `true`.                                                             |
| `placeNfcIconAtTheEnd`      | `bool`                     | Places NFC icon at the opposite side of the chip if set to `true`. Defaults to `false`.                             |
| `cardType`                  | `CardType`                 | Specifies card type. Defaults to `CardType.credit`. You can set it to `CardType.other` if you prefer not to specify a card type. This is optional.                                                               |
| `creditCardType`            | `CreditCardType`           | Specifies the credit card payment network logo. You can set it to `CreditCardType.none` if you prefer not to specify a card type and not show on the card UI. This is optional.                                                           |
| `cardProviderLogo`          | `Widget`                   | Adds a provider logo. Optional.                                                                                     |
| `backgroundDecorationImage` | `DecorationImage`          | Sets a background image. Optional.                                                                                  |
| `showValidThru`             | `bool`                     | Toggles "Valid Thru" section. Defaults to `true`.                                                                   |
| `currencySymbol`            | `String`                   | Currency symbol. Defaults to `$`.                                                                                   |
| `balance`                   | `double`                   | Balance amount. Defaults to `0.0`.                                                                                  |
| `showBalance`               | `bool`                     | Toggles the balance display. Defaults to `false`.                                                                   |
| `enableFlipping`            | `bool`                     | Enables card flipping. Defaults to `false`.                                                                         |
| `autoHideBalance`           | `bool`                     | Hides balance with a placeholder until tapped. Defaults to `false`.                                                 |
| `cvvNumber`                 | `String`                   | CVV number shown as `***`.                                                                                         |
| `disableHapticFeedBack`     | `bool`                     | Disables haptic feedback on interactions.                                                                          |
| `width`                     | `double`                   | Width of the card, up to a max of 300.                                                                              |
| `shouldMaskCardNumber`      | `bool`                     | Masks middle digits of the card number if set to `true`. Defaults to `true`.                                        |
| `controller`                | `CreditCardController`     | Controller for programmatic card flipping. Optional.                                                                |

### Example

```dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validFrom: '01/23',
  validThru: '01/28',
  topLeftColor: Colors.blue,
),
```

<img width="432" alt="u_credit_card_nfc_basic" src="https://user-images.githubusercontent.com/16848599/232335806-159f4873-7fcb-46e0-b559-bc5a59ab61bf.png">

By default, the card will have a chic blue gradient and an NFC icon. But don't worry, if you don't want the NFC icon, simply pass `doesSupportNfc: false`.

Want to switch things up and place the NFC icon on the opposite side of the chip? No problem! Just enable it by passing `placeNfcIconAtTheEnd: true`, but remember to also pass `doesSupportNfc: true`.

Let's make your app look as sleek as that shiny new credit card!

``` dart
CreditCardUi(
    cardHolderFullName: 'John Doe',
    cardNumber: '1234567812345678',
    validFrom: '01/23',
    validThru: '01/28',
    topLeftColor: Colors.blue,
    doesSupportNfc: true,
    placeNfcIconAtTheEnd: true, // 👈 NFC icon will be at the end,
),
```

<img width="432" alt="u_credit_card_nfc" src="https://user-images.githubusercontent.com/16848599/232332749-92d270b6-786d-4cb4-bc80-71654ce6fd56.png">

#### Custom Gradient

``` dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  topLeftColor: Colors.red,
  bottomRightColor: Colors.purpleAccent,
),
```

This will create a credit card user interface with a red-to-purple gradient.

<img width="432" alt="u_credit_card_gradient" src="https://user-images.githubusercontent.com/16848599/232333158-e0a3f488-cb36-4142-91a7-12d7d9546fca.png">

#### Setting the card width

If you want to set the width of the card, use `width:` property.
Better NOT wrap with `SizedBox(width: ..., child: CreditCardUi(....))`, instead use `width:` right from the `CreditCardUi()`

``` dart
CreditCardUi(
  width: 300, // 👈 this will set the width of the card
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  topLeftColor: Colors.red,
  bottomRightColor: Colors.purpleAccent,
),
```

Note: Setting up any value more than 300 is not considered, maximum width can be 300 only.

#### Additional Customizations

To further customize the card, you can add a background image by using the `backgroundDecorationImage` property. Additionally, you can include a logo for the card provider using the `cardProviderLogo` property. This logo can be positioned on either the left or the right side of the card using the `cardProviderLogoPosition` property.

If you want to specify a particular card type to display, you can set it using the `cardType` property. If you prefer not to specify a card type, you can set `cardType: CardType.other`.

Here is an example of how to use these customization options:

Example:

``` dart
CreditCardUi(
    cardHolderFullName: 'John Doe',
    cardNumber: '1234567812345678',
    validFrom: '01/23',
    validThru: '01/28',
    topLeftColor: Colors.blue,
    doesSupportNfc: true,
    placeNfcIconAtTheEnd: true,
    cardType: CardType.debit,
    cardProviderLogo: FlutterLogo(), // 👈 Set your logo here, supports any widget
    cardProviderLogoPosition: CardProviderLogoPosition.right,
    backgroundDecorationImage: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage( // 👈 `AssetImage` is also supported
        'https://....',
      ),
    ),
),
```

<img width="432" alt="Screenshot_2023-04-20_at_2 02 42_AM-removebg-preview" src="https://user-images.githubusercontent.com/16848599/233195568-5a197e2b-115c-46b1-876c-3428726f38cb.png">

To display the balance of your card, simply set `showBalance: true` and provide the balance amount using `balance: 200.0` (any double value). Enabling `autoHideBalance: true` will generate a placeholder labeled "Tap to see balance". Users can then tap on this placeholder to reveal the balance.

```dart
CreditCardUi(
    cardHolderFullName: 'John Doe',
    cardNumber: '1234567812345678',
    validFrom: '01/23',
    validThru: '01/28',
    topLeftColor: Colors.blue,
    doesSupportNfc: true,
    placeNfcIconAtTheEnd: true,
    cardType: CardType.debit,
    cardProviderLogo: FlutterLogo(),
    cardProviderLogoPosition: CardProviderLogoPosition.right,
    showBalance: true,
    balance: 128.32434343,
    autoHideBalance: true,
),
```

#### Card Flipping Animation

To enable the flipping animation by default, simply set the property `enableFlipping: true`. You can set CVV by `cvvNumber: 000`.

```dart
CreditCardUi(
    cardHolderFullName: 'John Doe',
    cardNumber: '1234567812345678',
    validFrom: '01/23',
    validThru: '01/28',
    topLeftColor: Colors.blue,
    doesSupportNfc: true,
    placeNfcIconAtTheEnd: true,
    cardType: CardType.debit,
    cardProviderLogo: FlutterLogo(),
    cardProviderLogoPosition: CardProviderLogoPosition.right,
    showBalance: true,
    balance: 128.32434343,
    autoHideBalance: true,
    enableFlipping: true, // 👈 Enables the flipping
    cvvNumber: '123', // 👈 CVV number to be shown on the back of the card
),
```

<img src="https://github.com/utpal-barman/u-credit-card-flutter/assets/16848599/350654f2-30c1-464b-93f2-7ed721f07792" width="432" />

#### Programmatic Card Flipping

You can control the card flip animation programmatically using the `CreditCardController`. This is useful when you want to flip the card in response to user actions, such as when a CVV input field gets focus.

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _cardController = CreditCardController();
  final _cvvFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Flip to back when CVV field gets focus
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
          controller: _cardController, // 👈 Pass the controller
          enableFlipping: true,
          cardHolderFullName: 'John Doe',
          cardNumber: '1234567812345678',
          validThru: '10/24',
          cvvNumber: '123',
        ),
        TextField(
          focusNode: _cvvFocusNode,
          decoration: InputDecoration(labelText: 'CVV'),
        ),
        ElevatedButton(
          onPressed: () => _cardController.flipCard(), // Manually flip
          child: Text('Flip Card'),
        ),
      ],
    );
  }
}
```

The `CreditCardController` provides three methods:

- `flipCard()`: Toggles between front and back
- `flipToFront()`: Flips to front side (if not already showing)
- `flipToBack()`: Flips to back side (if not already showing)

ধন্যবাদ

---

## Contributor

<a href="https://www.linkedin.com/in/utpal-barman/">
  <img src="https://user-images.githubusercontent.com/16848599/232288339-ecbd6cb1-3210-4304-b1e1-bc8434e290a8.png" width="100px" alt="Utpal Barman" style="border-radius:50%"/> <br /> <b>Utpal Barman 🇧🇩</b>
</a>
<br/> <br/>
<p>
 <a href="https://www.linkedin.com/in/utpal-barman/">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"
            alt="Contact Author"/>
 </a>
</p>

## License

This package is released under the [BSD 3-Clause License](https://raw.githubusercontent.com/utpal-barman/u-credit-card-flutter/main/LICENSE).
