# uCreditCard 💳
### Credit Card UI as Flutter Widget 💎

[![pub package](https://img.shields.io/pub/v/u_credit_card.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/u_credit_card)
[![Last Commits](https://img.shields.io/github/last-commit/utpal-barman/u-credit-card-flutter?logo=git&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/utpal-barman/u-credit-card-flutter?logo=github&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/utpal-barman/u-credit-card-flutter?logo=github&logoColor=white)](https://github.com/utpal-barman/u-credit-card-flutter)
[![License](https://img.shields.io/github/license/utpal-barman/u-credit-card-flutter?logo=open-source-initiative&logoColor=green)](https://github.com/utpal-barman/u-credit-card-flutter/blob/main/LICENSE)


🔥 "uCreditCard" is a Flutter package that offers a customizable solution for showing the UI of credit cards within your app.

<p align="center">
<img src="https://user-images.githubusercontent.com/16848599/232335515-d26e7600-c2a3-4c42-bde0-9c2e14787fb1.png" width="700"/>
</p>

### Resources 📚
- [Documentation](https://pub.dev/documentation/u_credit_card/latest/u_credit_card/CreditCardUi-class.html)
- [Pub Package](https://pub.dev/packages/u_credit_card)
- [GitHub Repository](https://github.com/utpal-barman/u-credit-card-flutter)


## Getting Started: Installation 💻

**✅ In order to start using Credit Card UI you must have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.**

Add `u_credit_card` to your `pubspec.yaml`:

```yaml
dependencies:
  u_credit_card: ^1.0.2
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
),
```

<img width="432" alt="u_credit_card_basic_setup" src="https://user-images.githubusercontent.com/16848599/232335773-5e6fdd6e-a4d9-4c01-a202-48cbca935cbe.png">


This will create a credit card user interface with the cardholder's name, card number, and validity date. For more advanced usage, see the following parameters:

### Parameters
| Name                        | Type                       | Description                                                                                                                                                                                                             |
|-----------------------------|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cardHolderFullName`        | `String`                   | The cardholder's full name. This is a required parameter.                                                                                                                                                               |
| `cardNumber`                | `String`                   | The full credit card number. This is a required parameter.                                                                                                                                                              |
| `validThru`                 | `String`                   | The validity date of the card. It must be in the format "mm/yy". This is a required parameter.                                                                                                                          |
| `validFrom`                 | `String`                   | The valid from the date of the card. It must be in the format "mm/yy". This parameter is optional.                                                                                                                      |
| `topLeftColor`              | `Color`                    | The top-left gradient color of the card. The default value is `Colors.purple`.                                                                                                                                          |
| `bottomRightColor`          | `Color`                    | The bottom-right gradient color of the card. If not specified, a darker version of the `topLeftColor` will be used.                                                                                                     |
| `doesSupportNfc`            | `bool`                     | A boolean value to indicate if the card supports NFC feature. The default value is `true`.                                                                                                                              |
| `placeNfcIconAtTheEnd`      | `bool`                     | A boolean value to place the NFC icon at the opposite side of the chip. The default value is `false`.                                                                                                                   |
| `cardType`                  | `CardType`                 | Specify the type of the card to display. By default, the value is set to `CardType.credit`. You can set it to `CardType.other` if you prefer not to specify a card type. This is optional.                              |
| `cardProviderLogo`          | `Widget`                   | Provide a widget for the logo of the card provider. If this parameter is not set, the card will be displayed without a logo. This is optional.                                                                          |
| `cardProviderLogoPosition`  | `CardProviderLogoPosition` | Set the position of the card provider logo on the card. The default value is `CardProviderLogoPosition.right`. You can set it to `CardProviderLogoPosition.left` or `CardProviderLogoPosition.right`. This is optional. |
| `backgroundDecorationImage` | `DecorationImage`          | Set a background image for the card. This parameter supports both asset and network images. If this parameter is not set, the card will be displayed without a background image. This is optional.                      |

#### Example
``` dart
CreditCardUi(
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validFrom: '01/23',
  validThru: '01/28',
  topLeftColor: Colors.blue,
),
```
<img width="432" alt="u_credit_card_nfc_basic" src="https://user-images.githubusercontent.com/16848599/232335806-159f4873-7fcb-46e0-b559-bc5a59ab61bf.png">

This will create a credit card user interface with the cardholder's name, card number, validity dates, and blue gradient colors. The card by default will have the NFC icon. If you don't want you can pass  `doesSupportNfc: false`

If you want to place the NFC icon on the opposite side of the chip please enable it by passing `placeNfcIconAtTheEnd: true`, in that case `doesSupportNfc: true` must be passed.

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


#### Scaling

If you want to scale the card, use `scale:` property.

If you set less than 1, the card size will be reduced,
if you set greater than 1, the card size will be increased.


``` dart
CreditCardUi(
  scale: 0.6, // 👈 this will make smaller than the regular size
  cardHolderFullName: 'John Doe',
  cardNumber: '1234567812345678',
  validThru: '10/24',
  topLeftColor: Colors.red,
  bottomRightColor: Colors.purpleAccent,
),
```

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


## Inspiration
There are already many credit card packages out there, but none of them look realistic. So, I've decided to create something that will look the same as our cards in real life. Additionally, this project was inspired by a [Native Android library](https://github.com/vinaygaba/CreditCardView).


## Contributor

<a href="https://www.linkedin.com/in/utpal-barman/">
  <img src="https://user-images.githubusercontent.com/16848599/232288339-ecbd6cb1-3210-4304-b1e1-bc8434e290a8.png" width="100px" alt="Utpal Barman" style="border-radius:50%"/> <br /> <b>Utpal Barman</b>
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

