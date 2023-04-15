// ignore_for_file: prefer_const_constructors

import 'package:credit_card_ui/credit_card_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditCardUi', () {
    test('can be instantiated', () {
      expect(
        CreditCardUi(
          cardHolderFullName: 'John Doe',
          cardNumber: '1234567812345678',
          validThru: '02/2025',
        ),
        isNotNull,
      );
    });
  });
}
