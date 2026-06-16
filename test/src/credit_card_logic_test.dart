import 'package:flutter_test/flutter_test.dart';
import 'package:u_credit_card/src/utils/credit_card_helper.dart';

void main() {
  group('CreditCardHelper.maskAndFormatCreditCardNumber', () {
    test('masks and formats the card number correctly', () {
      const fakeCardNumber = '1234567812345678';
      const expectedOutput = '1234 **** **** 5678';

      final maskedNumber = CreditCardHelper.maskAndFormatCreditCardNumber(
        fakeCardNumber,
      );

      expect(maskedNumber, expectedOutput);
    });

    test('returns the unmasked card number correctly when masking is disabled',
        () {
      const fakeCardNumber = '1234567812345678';
      const expectedOutput = '1234 5678 1234 5678';

      final unmaskedNumber = CreditCardHelper.maskAndFormatCreditCardNumber(
        fakeCardNumber,
        shouldMaskCardNumber: false,
      );

      expect(unmaskedNumber, expectedOutput);
    });

    test('masks a 15-digit Amex card with the correct group layout', () {
      // Length 15 still triggers masking (>= 12). Positions 4..11 inclusive
      // are masked; positions 12..14 are kept. Groups are 4-4-4-3.
      const amexCardNumber = '378282246310005';
      const expectedOutput = '3782 **** **** 005';

      final maskedNumber = CreditCardHelper.maskAndFormatCreditCardNumber(
        amexCardNumber,
      );

      expect(maskedNumber, expectedOutput);
    });

    test('leaves short card numbers (under 12 digits) unmasked', () {
      // Callers may pass partial input as the user types; below the
      // 12-digit threshold the helper still groups but skips masking.
      const shortNumber = '12345678';
      const expectedOutput = '1234 5678';

      final maskedNumber = CreditCardHelper.maskAndFormatCreditCardNumber(
        shortNumber,
      );

      expect(maskedNumber, expectedOutput);
    });

    test('preserves the first 4 and last 4 digits in the masked output', () {
      const cardNumber = '4111111111111234';
      final masked = CreditCardHelper.maskAndFormatCreditCardNumber(cardNumber);

      expect(masked.startsWith('4111 '), isTrue);
      expect(masked.endsWith(' 1234'), isTrue);
    });
  });
}
