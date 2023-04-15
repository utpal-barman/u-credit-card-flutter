import 'package:credit_card_ui/src/constants/assets.dart';
import 'package:credit_card_ui/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// Helper class for Credit Card
class CreditCardHelper {
  CreditCardHelper._();

  /// Masks Credit Card number with asterisks
  static String maskCreditCardNumber(String cardNumber) {
    final number = cardNumber.replaceAll(RegExp('[^0-9*]'), '');

    const visibleDigits = 4;
    final totalDigits = number.length;
    final visibleEnd = number.substring(
      totalDigits - visibleDigits,
    );

    if (totalDigits <= visibleDigits * 2) {
      return number;
    }

    final maskedLength = totalDigits - visibleDigits * 2;
    final maskedDigits = List.filled(maskedLength, '*').join();
    final visibleStart = number.substring(
      0,
      visibleDigits,
    );
    final maskedGroups = maskedDigits.splitMapJoin(
      RegExp('.{4}'),
      onMatch: (m) => '${m.group(0)} ',
      onNonMatch: (n) => n,
    );
    final output = '$visibleStart $maskedGroups $visibleEnd';

    return output;
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

  /// Get Card Logo String based on Card Number
  static String getCardLogo(String cardNumber) {
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
      case CreditCardType.other:
        return Assets.visaLogo;
    }
  }
}
