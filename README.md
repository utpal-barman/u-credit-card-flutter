# Credit Card UI 💳
🔥 "Credit Card UI" is a Flutter package that offers a customizable solution for showing the UI of credit cards within your app.

<p align="center">
<img src="https://user-images.githubusercontent.com/16848599/232289002-737ac7d3-9ba1-4c77-a1ba-b0cac85991ae.png" width="450"/>
</p>


## Installation 💻

**❗ In order to start using Credit Card UI you must have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.**

Add `u_credit_card` to your `pubspec.yaml`:

```yaml
dependencies:
  u_credit_card: ^1.0.0+4
```

Install it:

```sh
flutter packages get
```

---


## Usage
To use CreditCardUi, import the package:

``` dart
import 'package:u_credit_card/u_credit_card.dart';
```

Create widget of `CreditCardUi(...)` with the required parameters:

``` dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
)
```

<img width="432" alt="u_credit_card_1" src="https://user-images.githubusercontent.com/16848599/232253547-37db8038-e22f-43c4-8791-6c9c8778be8b.png">


This will create a credit card user interface with the cardholder's name, card number, and validity date. For more advanced usage, see the following parameters:

### Parameters
`cardHolderFullName` - A string value for the cardholder's full name. This is a required parameter.

`cardNumber` - A string value for the full credit card number. This is a required parameter.

`validThru` - A string value for the validity date of the card. It must be in the format "mm/yy". This is a required parameter.

`validFrom` - An optional string value for the valid from the date of the card. It must be in the format "mm/yy".

`topLeftColor` - A Color value for the top-left gradient color of the card. The default value is Colors. purple.

`bottomRightColor` - A Color value for the bottom-right gradient color of the card. If not specified, a darker version of the `topLeftColor` will be used.

`doesSupportNfc` - A boolean value to indicate if the card supports NFC feature. The default value is `true`.

`placeNfcIconAtTheEnd` - A boolean value to place the NFC icon at the opposite side of the chip. The deafult is `false`.

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

<img width="432" alt="u_credit_card_2" src="https://user-images.githubusercontent.com/16848599/232253805-72247691-6b67-4357-8fa9-03a1c21b1adf.png">

This will create a credit card user interface with the cardholder's name, card number, validity dates, and blue gradient colors. The card will not have the NFC icon.

If you want to place the NFC icon on the opposite side of the chip please enable it by passing `placeNfcIconAtTheEnd: true`

``` dart
CreditCardUi(
    cardHolderFullName: 'John Doe',
    cardNumber: '1234567812345678',
    validFrom: '01/23',
    validThru: '01/28',
    topLeftColor: Colors.blue,
    doesSupportNfc: true,
    placeNfcIconAtTheEnd: true, // <-- NFC icon will be at the end,
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
)
```
This will create a credit card user interface with a red-to-purple gradient.

<img width="432" alt="u_credit_card_gradient" src="https://user-images.githubusercontent.com/16848599/232333158-e0a3f488-cb36-4142-91a7-12d7d9546fca.png">


#### Scaling

If you want to scale the card, use `scale:` property.

If you set less than 1, the card size will be reduced,
if you set greater than 1, the card size will be increased.


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


## Contributor

<a href="https://www.linkedin.com/in/utpal-barman/">
  <img src="https://user-images.githubusercontent.com/16848599/232288339-ecbd6cb1-3210-4304-b1e1-bc8434e290a8.png" width="100px" alt="Utpal Barman" style="border-radius:50%"/> <br /> <b>Utpal Barman</b>
</a>

## License

This package is released under the [BSD 3-Clause License](https://raw.githubusercontent.com/utpal-barman/u-credit-card-flutter/main/LICENSE).

