import 'package:flutter_test/flutter_test.dart';
import 'package:u_credit_card/u_credit_card.dart';

void main() {
  group('CreditCardController', () {
    late CreditCardController controller;

    setUp(() {
      controller = CreditCardController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state should be not flipped', () {
      expect(controller.isFlipped, false);
    });

    test('setFlipState updates the flip state', () {
      expect(controller.isFlipped, false);

      controller.setFlipState(isFlipped: true);
      expect(controller.isFlipped, true);

      controller.setFlipState(isFlipped: false);
      expect(controller.isFlipped, false);
    });

    test('setFlipState notifies listeners when state changes', () {
      var notificationCount = 0;
      controller
        ..addListener(() {
          notificationCount++;
        })
        ..setFlipState(isFlipped: true);
      expect(notificationCount, 1);

      controller.setFlipState(isFlipped: false);
      expect(notificationCount, 2);
    });

    test('setFlipState does not notify listeners when state is same', () {
      var notificationCount = 0;
      controller
        ..addListener(() {
          notificationCount++;
        })
        ..setFlipState(isFlipped: false);
      expect(notificationCount, 0);

      controller.setFlipState(isFlipped: false);
      expect(notificationCount, 0);
    });

    test('flipCard calls the registered callback', () {
      var callbackCalled = false;
      controller
        ..setFlipCallback(() {
          callbackCalled = true;
        })
        ..flipCard();
      expect(callbackCalled, true);
    });

    test('flipCard does nothing if no callback is set', () {
      // Should not throw
      expect(() => controller.flipCard(), returnsNormally);
    });

    test('flipToFront flips only when card is showing back', () {
      var flipCount = 0;
      controller
        ..setFlipCallback(() {
          flipCount++;
        })

        // Initially showing front (isFlipped = false)
        ..flipToFront();
      expect(flipCount, 0); // Should not flip

      // Set to back
      controller
        ..setFlipState(isFlipped: true)
        ..flipToFront();
      expect(flipCount, 1); // Should flip to front
    });

    test('flipToBack flips only when card is showing front', () {
      var flipCount = 0;
      controller
        ..setFlipCallback(() {
          flipCount++;
        })

        // Initially showing front (isFlipped = false)
        ..flipToBack();
      expect(flipCount, 1); // Should flip to back

      // Set to back
      controller
        ..setFlipState(isFlipped: true)
        ..flipToBack();
      expect(flipCount, 1); // Should not flip again
    });

    test('multiple controllers can work independently', () {
      final controller1 = CreditCardController();
      final controller2 = CreditCardController();

      controller1.setFlipState(isFlipped: true);
      controller2.setFlipState(isFlipped: false);

      expect(controller1.isFlipped, true);
      expect(controller2.isFlipped, false);

      controller1.dispose();
      controller2.dispose();
    });

    test('controller can be disposed safely', () {
      final testController = CreditCardController();
      expect(
        testController.dispose,
        returnsNormally,
      );
    });
  });
}
