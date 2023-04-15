// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:u_credit_card/u_credit_card.dart';

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
