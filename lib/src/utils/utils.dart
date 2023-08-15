import 'package:u_credit_card/u_credit_card.dart';

///
class CreditCard {
  ///
  CreditCard(this.number);

  ///
  final String number;

  ///
  bool get isValid => _validate();

  ///
  CreditCardType get cardType => _detectCreditCardType();

  bool _validate() {
    final cardNumber = number.trim().replaceAll(RegExp('[^0-9]'), '');

    if (cardNumber.isEmpty) {
      return false;
    }

    var checksum = 0;
    var isOddDigit = true;

    for (var i = cardNumber.length - 1; i >= 0; i--) {
      var digit = int.parse(cardNumber[i]);

      if (isOddDigit) {
        checksum += digit;
      } else {
        digit *= 2;
        checksum += (digit > 9) ? digit - 9 : digit;
      }

      isOddDigit = !isOddDigit;
    }

    return checksum % 10 == 0;
  }

  CreditCardType _detectCreditCardType() {
    final cardNumber = number.trim().replaceAll(RegExp('[^0-9]'), '');

    if (cardNumber.isEmpty) {
      return CreditCardType.none;
    }

    if (cardNumber.startsWith('4')) {
      return CreditCardType.visa;
    }

    if (cardNumber.startsWith('5') && RegExp('^5[1-5]').hasMatch(cardNumber)) {
      return CreditCardType.mastercard;
    }

    if (cardNumber.startsWith('3') &&
        (cardNumber.startsWith('34') || cardNumber.startsWith('37'))) {
      return CreditCardType.amex;
    }

    if (cardNumber.startsWith('6') &&
        RegExp('^6(?:011|5[0-9]{2})').hasMatch(cardNumber)) {
      return CreditCardType.discover;
    }

    return CreditCardType.none;
  }
}
