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

    testWidgets(
      'controller has no effect when enableFlipping is false',
      (tester) async {
        // When flipping is disabled the controller is never wired up, so
        // flipCard() is a no-op and isFlipped stays false. Documenting
        // this prevents callers from being surprised when their controller
        // appears inert.
        final controller = CreditCardController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CreditCardUi(
                controller: controller,
                cardHolderFullName: 'John Doe',
                cardNumber: '1234567812345678',
                validThru: '02/2025',
              ),
            ),
          ),
        );

        controller.flipCard();
        await tester.pumpAndSettle();

        expect(controller.isFlipped, false);

        controller.dispose();
      },
    );

    testWidgets(
      'renders the balance with the configured currency symbol',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CreditCardUi(
                cardHolderFullName: 'John Doe',
                cardNumber: '1234567812345678',
                validThru: '02/2025',
                showBalance: true,
                balance: 100.5,
                currencySymbol: '€',
              ),
            ),
          ),
        );

        expect(find.text('€100.50'), findsOneWidget);
      },
    );

    testWidgets(
      'renders the "TAP TO SEE BALANCE" placeholder when autoHideBalance is on',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CreditCardUi(
                cardHolderFullName: 'John Doe',
                cardNumber: '1234567812345678',
                validThru: '02/2025',
                showBalance: true,
                balance: 128.32,
                autoHideBalance: true,
              ),
            ),
          ),
        );

        expect(find.text('TAP TO SEE BALANCE'), findsOneWidget);
        expect(find.text(r'$128.32'), findsNothing);
      },
    );

    testWidgets(
      'renders the card-type label for each CardType',
      (tester) async {
        Future<void> pump(CardType type) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CreditCardUi(
                  cardHolderFullName: 'John Doe',
                  cardNumber: '1234567812345678',
                  validThru: '02/2025',
                  cardType: type,
                ),
              ),
            ),
          );
        }

        await pump(CardType.credit);
        expect(find.text('CREDIT'), findsOneWidget);

        await pump(CardType.debit);
        expect(find.text('DEBIT'), findsOneWidget);

        await pump(CardType.prepaid);
        expect(find.text('PREPAID'), findsOneWidget);

        await pump(CardType.giftCard);
        expect(find.text('GIFT CARD'), findsOneWidget);

        await pump(CardType.other);
        // CardType.other returns an empty label, so none of the named labels
        // should appear anywhere in the tree.
        expect(find.text('CREDIT'), findsNothing);
        expect(find.text('DEBIT'), findsNothing);
        expect(find.text('PREPAID'), findsNothing);
        expect(find.text('GIFT CARD'), findsNothing);
      },
    );

    testWidgets(
      'shouldMaskCardNumber: false exposes the full number in the tree',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CreditCardUi(
                cardHolderFullName: 'John Doe',
                cardNumber: '1234567812345678',
                validThru: '02/2025',
                shouldMaskCardNumber: false,
              ),
            ),
          ),
        );

        // Grouped, no asterisks.
        expect(find.text('1234 5678 1234 5678'), findsOneWidget);
      },
    );

    testWidgets(
      'controller reassignment detaches the previous controller',
      (tester) async {
        // This pins the didUpdateWidget path: when the widget is rebuilt with
        // a new controller, the old one is detached (flipCard becomes a no-op)
        // and the new one takes over.
        final firstController = CreditCardController();
        final secondController = CreditCardController();

        Widget build(CreditCardController controller) {
          return MaterialApp(
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
          );
        }

        await tester.pumpWidget(build(firstController));
        expect(firstController.isFlipped, false);

        // Swap to the second controller.
        await tester.pumpWidget(build(secondController));

        // The old controller is detached; flipCard is a no-op.
        firstController.flipCard();
        await tester.pumpAndSettle();
        expect(firstController.isFlipped, false);

        // The new controller drives the widget.
        secondController.flipCard();
        await tester.pumpAndSettle();
        expect(secondController.isFlipped, true);

        firstController.dispose();
        secondController.dispose();
      },
    );
  });
}
