# Credit Card UI
💳 "Credit Card UI" is a Flutter package that offers a customizable solution for showing the UI of credit cards within your app.

## Installation 💻

**❗ In order to start using Credit Card UI you must have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.**

Add `credit_card_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  credit_card_ui: ^1.0.0+1
```

Install it:

```sh
flutter packages get
```

---

`credit_card_ui` is a Flutter package that provides an easy-to-use and customizable credit card user interface. It offers a widget `CreditCardUi` that can be used to create a credit card user interface with customizable options like gradients, logos, and NFC support.

## Installation
To use `credit_card_ui`, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  credit_card_ui: ^1.0.0+1
```

Then, run flutter packages get in your terminal to install the package.

## Usage
To use CreditCardUi, import the package:

``` dart
import 'package:credit_card_ui/credit_card_ui.dart';
```

Create widget of `CreditCardUi(...)` with the required parameters:

``` dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
)
```

This will create a credit card user interface with the cardholder's name, card number, and validity date. For more advanced usage, see the following parameters:

### Parameters
`cardHolderFullName` - A string value for the cardholder's full name. This is a required parameter.

`cardNumber` - A string value for the full credit card number. This is a required parameter.

`validThru` - A string value for the validity date of the card. It must be in the format "mm/yy". This is a required parameter.

`validFrom` - An optional string value for the valid from the date of the card. It must be in the format "mm/yy".

`topLeftColor` - A Color value for the top-left gradient color of the card. The default value is Colors. purple.

`bottomRightColor` - A Color value for the bottom-right gradient color of the card. If not specified, a darker version of the `topLeftColor` will be used.

`doesSupportNfc` - A boolean value to indicate if the card supports NFC feature. The default value is `true`.

#### Example
``` dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validFrom: '01/23',
  validThru: '01/28',
  topLeftColor: Colors.blue,
  doesSupportNfc: false, // Set to true if card support NFC
),
```
This will create a credit card user interface with the cardholder's name, card number, validity dates, and blue gradient colors. The card will not have the NFC icon.



#### Custom Gradient

``` dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  topLeftColor: Colors.red,
  bottomRightColor: Colors.purpleAccent,
)
```
This will create a credit card user interface with the red to yellow gradient.

If you want to scale the card, use `scale:` property.

If you set less than 1, card size will be reduced,
if you set greater than 1, card size will be increased.


``` dart
CreditCardUi(
  scale: 0.6, // <-- this will make smaller than the normal size
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  topLeftColor: Colors.red,
  bottomRightColor: Colors.purpleAccent,
)
```