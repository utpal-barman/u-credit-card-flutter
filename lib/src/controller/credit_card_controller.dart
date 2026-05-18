import 'package:flutter/foundation.dart';

/// A controller for managing the credit card flipping state.
///
/// This controller allows programmatic control of the credit card flip
/// animation. Use [flipCard] to toggle between front and back sides, or
/// [flipToFront] and [flipToBack] for explicit control.
///
/// Example:
/// ```dart
/// final controller = CreditCardController();
///
/// CreditCardUi(
///   controller: controller,
///   enableFlipping: true,
///   cardHolderFullName: 'John Doe',
///   cardNumber: '1234567812345678',
///   validThru: '10/24',
/// )
///
/// // Later, flip the card programmatically
/// controller.flipCard();
/// ```
class CreditCardController extends ChangeNotifier {
  /// Creates a credit card controller.
  CreditCardController();

  /// Whether the card is currently showing the back side.
  bool _isFlipped = false;

  /// Gets the current flip state.
  ///
  /// Returns `true` if the card is showing the back side, `false` if
  /// showing the front side.
  bool get isFlipped => _isFlipped;

  /// Callback invoked when the card should flip.
  ///
  /// This is set internally by the widget and should not be called directly.
  VoidCallback? _flipCallback;

  /// Registers the widget's flip action with this controller.
  ///
  /// Called by `CreditCardUi` during build to wire its internal animation
  /// up to [flipCard]. Application code should not call this directly.
  @internal
  // ignore: use_setters_to_change_properties
  void setFlipCallback(VoidCallback callback) {
    _flipCallback = callback;
  }

  /// Syncs the controller's flip state with the widget's animation.
  ///
  /// Called by `CreditCardUi` as the flip animation progresses so listeners
  /// see [isFlipped] update in real time. Application code should not call
  /// this directly — use [flipCard], [flipToFront], or [flipToBack].
  @internal
  void setFlipState({required bool isFlipped}) {
    if (_isFlipped != isFlipped) {
      _isFlipped = isFlipped;
      notifyListeners();
    }
  }

  /// Toggles the card between front and back sides.
  ///
  /// If the card is currently showing the front, it will flip to the back.
  /// If showing the back, it will flip to the front.
  void flipCard() {
    _flipCallback?.call();
  }

  /// Flips the card to show the front side.
  ///
  /// If the card is already showing the front, this method does nothing.
  void flipToFront() {
    if (_isFlipped) {
      flipCard();
    }
  }

  /// Flips the card to show the back side.
  ///
  /// If the card is already showing the back, this method does nothing.
  void flipToBack() {
    if (!_isFlipped) {
      flipCard();
    }
  }
}
