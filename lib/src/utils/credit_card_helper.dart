import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/assets.dart';
import 'package:u_credit_card/src/utils/utils.dart';
import 'package:u_credit_card/u_credit_card.dart';

/// Helper class for Credit Card
class CreditCardHelper {
  CreditCardHelper._();

  /// Masks Credit Card number with asterisks
  static String maskCreditCardNumber(String cardNumber) {
    final length = cardNumber.length;
    var maskedNumber = '';

    for (var i = 0; i < length; i++) {
      if (i < 4 || (i >= 12)) {
        // keep the first 4 digits and the last 4 digits visible
        maskedNumber += cardNumber[i];
      } else {
        // mask the digits between 4 and the length-4 with asterisks
        maskedNumber += '*';
      }
    }

    return groupDigits(maskedNumber);
  }

  /// Group the masked number in sets of 4 digits.
  static String groupDigits(String input) {
    if (input.isEmpty) {
      return input;
    }

    final groups = <String>[];
    final length = input.length;

    for (var i = 0; i < length; i += 4) {
      final groupLength = i + 4 <= length ? 4 : length - i;
      final group = input.substring(i, i + groupLength);
      groups.add(group);
    }

    return groups.join(' ');
  }

  /// Masks validity into `mm/yy`,
  /// and cut all the strings after the 5th character
  static String maskValidity(String validity) {
    if (validity.length < 5) {
      return validity;
    }

    return validity.substring(0, 5).replaceAll(' ', '').replaceAll('-', '/');
  }

  /// Returns a darker version of any color
  static Color getDarkerColor(Color color) {
    // Calculate the luminance of the input color
    final luminance = color.computeLuminance();

    // Set the amount by which you want to make the color darker
    const darkenAmount = 0.2;

    // Adjust the luminance to make the color darker
    final newLuminance = (luminance - darkenAmount).clamp(0.0, 1.0);

    // Return the new darker color
    return Color.fromRGBO(
      (color.red * newLuminance).toInt(),
      (color.green * newLuminance).toInt(),
      (color.blue * newLuminance).toInt(),
      color.opacity,
    );
  }

  /// Get Card Logo String based on `cardNumber`
  static String getCardLogoFromCardNumber({required String cardNumber}) {
    final creditCard = CreditCard(cardNumber);

    final cardType = creditCard.cardType;

    switch (cardType) {
      case CreditCardType.visa:
        return Assets.visaLogo;
      case CreditCardType.mastercard:
        return Assets.masterCardLogo;
      case CreditCardType.amex:
        return Assets.amexLogo;
      case CreditCardType.discover:
        return Assets.discoverLogo;
      case CreditCardType.none:
        return '';
    }
  }

  /// Get Card Logo String based on [CreditCardType]
  static String getCardLogoFromType({required CreditCardType creditCardType}) {
    final cardType = creditCardType;

    switch (cardType) {
      case CreditCardType.visa:
        return Assets.visaLogo;
      case CreditCardType.mastercard:
        return Assets.masterCardLogo;
      case CreditCardType.amex:
        return Assets.amexLogo;
      case CreditCardType.discover:
        return Assets.discoverLogo;
      case CreditCardType.none:
        return '';
    }
  }
}
