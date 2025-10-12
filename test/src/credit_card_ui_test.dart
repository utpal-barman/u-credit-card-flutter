// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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

    testWidgets('can be rendered with controller', (tester) async {
      final controller = CreditCardController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditCardUi(
              controller: controller,
              enableFlipping: true,
              cardHolderFullName: 'John Doe',
              cardNumber: '1234567812345678',
              validThru: '02/2025',
              cvvNumber: '123',
            ),
          ),
        ),
      );

      expect(find.byType(CreditCardUi), findsOneWidget);

      controller.dispose();
    });

    testWidgets('controller can flip card programmatically', (tester) async {
      final controller = CreditCardController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditCardUi(
              controller: controller,
              enableFlipping: true,
              cardHolderFullName: 'John Doe',
              cardNumber: '1234567812345678',
              validThru: '02/2025',
              cvvNumber: '123',
            ),
          ),
        ),
      );

      // Initially showing front
      expect(controller.isFlipped, false);

      // Flip to back
      controller.flipCard();
      await tester.pumpAndSettle();

      // Verify flip state updated
      expect(controller.isFlipped, true);

      // Flip back to front
      controller.flipCard();
      await tester.pumpAndSettle();

      expect(controller.isFlipped, false);

      controller.dispose();
    });

    testWidgets('flipToBack and flipToFront work correctly', (tester) async {
      final controller = CreditCardController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditCardUi(
              controller: controller,
              enableFlipping: true,
              cardHolderFullName: 'John Doe',
              cardNumber: '1234567812345678',
              validThru: '02/2025',
              cvvNumber: '123',
            ),
          ),
        ),
      );

      // Flip to back
      controller.flipToBack();
      await tester.pumpAndSettle();
      expect(controller.isFlipped, true);

      // Try flipping to back again (should not change)
      controller.flipToBack();
      await tester.pumpAndSettle();
      expect(controller.isFlipped, true);

      // Flip to front
      controller.flipToFront();
      await tester.pumpAndSettle();
      expect(controller.isFlipped, false);

      // Try flipping to front again (should not change)
      controller.flipToFront();
      await tester.pumpAndSettle();
      expect(controller.isFlipped, false);

      controller.dispose();
    });
  });
}
