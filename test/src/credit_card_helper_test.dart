import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:u_credit_card/src/constants/assets.dart';
import 'package:u_credit_card/src/utils/credit_card_helper.dart';
import 'package:u_credit_card/u_credit_card.dart';

void main() {
  group('CreditCardHelper.maskValidity', () {
    test('returns mm/yy unchanged when already correctly formatted', () {
      expect(CreditCardHelper.maskValidity('01/25'), '01/25');
    });

    test('converts a single dash separator to a slash', () {
      expect(CreditCardHelper.maskValidity('01-25'), '01/25');
    });

    test('strips a space separator', () {
      // '01 25' is 5 chars; the space is stripped, leaving '0125'.
      expect(CreditCardHelper.maskValidity('01 25'), '0125');
    });

    test('truncates input longer than 5 characters', () {
      // First 5 chars are taken before transformations are applied.
      expect(CreditCardHelper.maskValidity('01/2025'), '01/20');
    });

    test('passes short input through unchanged', () {
      expect(CreditCardHelper.maskValidity('1/2'), '1/2');
      expect(CreditCardHelper.maskValidity(''), '');
    });
  });

  group('CreditCardHelper.groupDigits', () {
    test('returns empty string for empty input', () {
      expect(CreditCardHelper.groupDigits(''), '');
    });

    test('returns single group for inputs of 4 or fewer characters', () {
      expect(CreditCardHelper.groupDigits('1'), '1');
      expect(CreditCardHelper.groupDigits('1234'), '1234');
    });

    test('groups a standard 16-digit card into four 4-digit chunks', () {
      expect(
        CreditCardHelper.groupDigits('1234567812345678'),
        '1234 5678 1234 5678',
      );
    });

    test(
      'groups a 15-digit Amex card into 4-4-4-3 chunks (current behavior)',
      () {
        expect(
          CreditCardHelper.groupDigits('378282246310005'),
          '3782 8224 6310 005',
        );
      },
    );
  });

  group('CreditCardHelper.maskAndFormatCreditCardNumber', () {
    test('masks the middle digits of a 16-digit card', () {
      expect(
        CreditCardHelper.maskAndFormatCreditCardNumber('1234567812345678'),
        '1234 **** **** 5678',
      );
    });

    test('returns the full number when masking is disabled', () {
      expect(
        CreditCardHelper.maskAndFormatCreditCardNumber(
          '1234567812345678',
          shouldMaskCardNumber: false,
        ),
        '1234 5678 1234 5678',
      );
    });

    test('does not mask card numbers shorter than 12 digits', () {
      // The current implementation only applies masking to numbers >= 12 chars.
      // Anything shorter is grouped as-is even when masking is requested.
      expect(
        CreditCardHelper.maskAndFormatCreditCardNumber('12345678'),
        '1234 5678',
      );
    });

    test('preserves the first 4 and last 4 digits exactly', () {
      const input = '4111111111111234';
      final out = CreditCardHelper.maskAndFormatCreditCardNumber(input);
      expect(out.startsWith('4111 '), isTrue);
      expect(out.endsWith(' 1234'), isTrue);
    });
  });

  group('CreditCardHelper.getDarkerColor', () {
    test('darkens a bright color', () {
      const input = Colors.white;
      final out = CreditCardHelper.getDarkerColor(input);
      expect(
        out.computeLuminance(),
        lessThan(input.computeLuminance()),
      );
    });

    test('preserves the input opacity', () {
      const input = Color.fromRGBO(120, 200, 50, 0.6);
      final out = CreditCardHelper.getDarkerColor(input);
      expect(out.a, closeTo(input.a, 0.001));
    });

    test('clamps when given an already-dark color', () {
      // Black has luminance 0; the algorithm clamps to 0 and returns black.
      const input = Colors.black;
      final out = CreditCardHelper.getDarkerColor(input);
      expect(out.computeLuminance(), 0);
    });
  });

  group('CreditCardHelper.getCardLogoFromCardNumber', () {
    test('detects Visa from a leading 4', () {
      expect(
        CreditCardHelper.getCardLogoFromCardNumber(
          cardNumber: '4111111111111111',
        ),
        Assets.visaLogo,
      );
    });

    test('detects Mastercard from a 51-55 leading range', () {
      expect(
        CreditCardHelper.getCardLogoFromCardNumber(
          cardNumber: '5500000000000004',
        ),
        Assets.masterCardLogo,
      );
    });

    test('detects American Express from leading 34 or 37', () {
      expect(
        CreditCardHelper.getCardLogoFromCardNumber(
          cardNumber: '378282246310005',
        ),
        Assets.amexLogo,
      );
    });

    test('detects Discover from a 6011 prefix', () {
      expect(
        CreditCardHelper.getCardLogoFromCardNumber(
          cardNumber: '6011111111111117',
        ),
        Assets.discoverLogo,
      );
    });

    test('returns an empty string for unrecognized BIN ranges', () {
      expect(
        CreditCardHelper.getCardLogoFromCardNumber(
          cardNumber: '9999999999999999',
        ),
        '',
      );
    });

    test('returns an empty string for an empty card number', () {
      expect(
        CreditCardHelper.getCardLogoFromCardNumber(cardNumber: ''),
        '',
      );
    });
  });

  group('CreditCardHelper.getCardLogoFromType', () {
    test('maps each CreditCardType to its asset path', () {
      expect(
        CreditCardHelper.getCardLogoFromType(
          creditCardType: CreditCardType.visa,
        ),
        Assets.visaLogo,
      );
      expect(
        CreditCardHelper.getCardLogoFromType(
          creditCardType: CreditCardType.mastercard,
        ),
        Assets.masterCardLogo,
      );
      expect(
        CreditCardHelper.getCardLogoFromType(
          creditCardType: CreditCardType.amex,
        ),
        Assets.amexLogo,
      );
      expect(
        CreditCardHelper.getCardLogoFromType(
          creditCardType: CreditCardType.discover,
        ),
        Assets.discoverLogo,
      );
      expect(
        CreditCardHelper.getCardLogoFromType(
          creditCardType: CreditCardType.none,
        ),
        '',
      );
    });
  });
}
