// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_credit_card/src/constants/ui_constants.dart';
import 'package:u_credit_card/src/controller/credit_card_controller.dart';
import 'package:u_credit_card/src/ui/credit_card_chip_nfc_view.dart';
import 'package:u_credit_card/src/ui/credit_card_holder_name_view.dart';
import 'package:u_credit_card/src/ui/credit_card_text.dart';
import 'package:u_credit_card/src/ui/credit_card_top_section_view.dart';
import 'package:u_credit_card/src/ui/credit_card_validity_view.dart';
import 'package:u_credit_card/src/utils/credit_card_helper.dart';

/// Types of Cards.
enum CardType {
  /// Credit Card
  credit,

  /// Debit Card
  debit,

  /// Prepaid Card
  prepaid,

  /// Gift Card
  giftCard,

  /// Others
  other,
}

/// Types of payment network.
enum CreditCardType {
  /// VISA
  visa,

  /// Mastercard
  mastercard,

  /// AMEX
  amex,

  /// Discover
  discover,

  /// None
  none,
}

/// Position of the Card Provider logo.
/// Left or Right in the top part of the card.
enum CardProviderLogoPosition {
  /// Set the logo to the left side.
  left,

  /// Set the logo to the left side.
  right;

  /// Find if the logo is set to left or not.
  bool get isLeft => this == CardProviderLogoPosition.left;
}

/// Creates Credit Card UI.
class CreditCardUi extends StatelessWidget {
  /// Creates Credit Card UI.
  const CreditCardUi({
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.validThru,
    this.validFrom,
    this.topLeftColor = Colors.purple,
    this.bottomRightColor,
    this.doesSupportNfc = true,
    @Deprecated(
      '[scale] is deprecated, use [width] instead, will be removed soon',
    )
    this.scale = 1.0,
    this.width,
    this.placeNfcIconAtTheEnd = false,
    this.cardType = CardType.credit,
    this.creditCardType,
    this.cardProviderLogo,
    this.cardProviderLogoPosition = CardProviderLogoPosition.right,
    this.backgroundDecorationImage,
    this.showValidFrom = true,
    this.showValidThru = true,
    super.key,
    this.currencySymbol = r'$',
    this.balance = 0.0,
    this.showBalance = false,
    this.autoHideBalance = false,
    this.enableFlipping = false,
    this.cvvNumber = '***',
    this.disableHapticFeedBack = false,
    this.shouldMaskCardNumber = true,
    this.controller,
  });

  /// Full Name of the Card Holder.
  final String cardHolderFullName;

  /// Full credit card number, can support asterisks.
  final String cardNumber;

  /// Enter valid from date of the card month and year like mm/yy,
  ///
  /// Example 01/23, here 01 means month January & 23 means year 2023.
  /// Optional field, can be skipped.
  final String? validFrom;

  /// Enter validity of the card month and year like mm/yy.
  ///
  /// Example 01/28, here 01 means month January & 28 means year 2028.
  final String validThru;

  /// Determines whether to show the "Valid From" segment on the card.
  ///
  /// If set to `true`, the "Valid From" segment will be displayed.
  /// If set to `false`, it will be hidden. The default value is `true`.
  final bool showValidFrom;

  /// Determines whether to show the "Valid Thru" segment on the card.
  ///
  /// If set to `true`, the "Valid Thru" segment will be displayed.
  /// If set to `false`, it will be hidden. The default value is `true`.
  final bool showValidThru;

  /// Top Left Color for the Gradient,
  /// by default it's `Colors.purple`.
  ///
  /// Tip: Avoid light colors, because texts are now white.
  final Color topLeftColor;

  /// Bottom Left Color for the Gradient,
  /// by default it's deeper version of `topLeftColor`.
  ///
  /// Tip: Avoid light colors, because texts are now white.
  final Color? bottomRightColor;

  /// Shows a NFC icon to tell user if the card supports NFC feature.
  ///
  /// By default it is `true`.
  final bool doesSupportNfc;

  /// Places NFC icon at the opposite side of the chip,
  ///
  /// For this value to be impacted,
  /// card must have NFC cababilities and you must set `doesSupportNfc: true`.
  /// By default `placeNfcIconAtTheEnd : false`,
  /// so, icon will be beside the chip if nfc is enabled.
  final bool placeNfcIconAtTheEnd;

  /// Can scale the credit card.
  ///
  /// if you want reduce the size,
  /// set the value less than 1, else set greater than 1.
  ///
  /// By default the value is 1.0.
  @Deprecated(
    '[scale] is deprecated, use [width] instead, will be removed soon',
  )
  final double scale;

  /// Defines Card max width.
  ///
  /// By default [width] is 300, if any value is assigned greater than 300,
  /// It will consider it as 300.
  final double? width;

  /// Provide the type of the card - credit or debit.
  /// By default, it's `CardType.credit`
  ///
  /// Set `CardType.other` if you don't want to set anything.
  final CardType cardType;

  /// Set Credit card type to set network provider logo - VISA, Mastercard, etc.
  ///
  /// Set `creditCardType: CreditCardType.none` to disable showing the logo.
  /// If this value is skipped, the card will show the logo automatically
  /// based on the `cardNumber`.
  final CreditCardType? creditCardType;

  /// Provide the logo of the card provider (Optional).
  final Widget? cardProviderLogo;

  /// Set the position of the card provider,
  /// by default, it is on the right.
  ///
  /// Set `CardProviderLogoPosition.left` or `CardProviderLogoPosition.right`.
  final CardProviderLogoPosition cardProviderLogoPosition;

  /// Set Background image, can support both asset and network image.
  final DecorationImage? backgroundDecorationImage;

  /// The symbol used to represent the currency.
  /// By default, it uses US Dollar sign ($)
  final String? currencySymbol;

  /// The balance amount.
  final double? balance;

  /// A boolean flag indicating whether to show the balance.
  final bool? showBalance;

  /// A boolean flag indicating whether card flipping is enabled.
  final bool? enableFlipping;

  /// A boolean flag indicating to enable the auto hiding balance feature.
  ///
  /// In this case, the placeholder will be shown instead of the balance.
  final bool? autoHideBalance;

  /// CVV number of the card, use *** if you think this is sensitive,
  /// by default it will show ***
  final String? cvvNumber;

  /// A boolean flag to disable the haptic feedback.
  /// Example — card flipping or tapping on placeholder to see balance
  final bool? disableHapticFeedBack;

  /// Determines whether to display the full card number to the user.
  /// Displaying the full card number is not recommended due to its sensitivity.
  /// By default, this value is `true` and the middle digits are masked with
  /// asterisks.
  final bool shouldMaskCardNumber;

  /// Controller for programmatically flipping the card.
  ///
  /// Use this controller to flip the card between front and back sides
  /// programmatically. This is useful when you want to show the CVV field
  /// when a CVV input field gets focus, for example.
  ///
  /// Example:
  /// ```dart
  /// final controller = CreditCardController();
  ///
  /// // Later, flip the card
  /// controller.flipCard();
  /// ```
  final CreditCardController? controller;

  @override
  Widget build(BuildContext context) {
    final cardNumberFormated = CreditCardHelper.maskAndFormatCreditCardNumber(
      cardNumber.replaceAll(' ', '').replaceAll('-', ''),
      shouldMaskCardNumber: shouldMaskCardNumber,
    );

    final validFromMasked = validFrom == null
        ? null
        : CreditCardHelper.maskValidity(
            validFrom!,
          );

    final validThruMasked = CreditCardHelper.maskValidity(
      validThru,
    );

    final conditionalBottomRightColor = bottomRightColor ??
        CreditCardHelper.getDarkerColor(
          topLeftColor,
        );

    Widget cardLogoWidget;
    final cardLogoString = CreditCardHelper.getCardLogoFromCardNumber(
      cardNumber: cardNumberFormated,
    );

    if (cardLogoString.isEmpty || creditCardType == CreditCardType.none) {
      cardLogoWidget = const SizedBox.shrink();
    } else if (creditCardType != null) {
      cardLogoWidget = Image.asset(
        CreditCardHelper.getCardLogoFromType(creditCardType: creditCardType!),
        package: UiConstants.packageName,
      );
    } else {
      cardLogoWidget = Image.asset(
        CreditCardHelper.getCardLogoFromCardNumber(
          cardNumber: cardNumberFormated,
        ),
        package: UiConstants.packageName,
      );
    }

    final frontSide = SizedBox(
      key: const ValueKey('FrontSide'),
      width: 300,
      child: AspectRatio(
        aspectRatio: 1.5789,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                topLeftColor,
                conditionalBottomRightColor,
              ],
            ),
            image: backgroundDecorationImage,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 16,
                top: 16,
                child: SizedBox(
                  height: 32,
                  width: 268,
                  child: CreditCardTopLogo(
                    enableFlipping: enableFlipping,
                    currencySymbol: currencySymbol,
                    autoHideBalance: autoHideBalance,
                    balance: balance,
                    showBalance: showBalance,
                    cardType: cardType,
                    cardProviderLogo: cardProviderLogo,
                    cardProviderLogoPosition: cardProviderLogoPosition,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 64,
                child: CreditCardChipNfcView(
                  doesSupportNfc: doesSupportNfc,
                  placeNfcIconAtTheEnd: placeNfcIconAtTheEnd,
                ),
              ),
              Positioned(
                top: 138,
                left: 20,
                child: CreditCardValidityView(
                  validFromMasked: validFromMasked,
                  validThruMasked: validThruMasked,
                  showValidFrom: showValidFrom,
                  showValidThru: showValidThru,
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: SizedBox(
                  height: 36,
                  width: 84,
                  child: AnimatedSwitcher(
                    duration: UiConstants.animationDuration,
                    child: Container(
                      key: ValueKey(cardNumberFormated),
                      child: cardLogoWidget,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 160,
                left: 20,
                child: CreditCardHolderNameView(
                  cardHolderFullName: cardHolderFullName,
                ),
              ),
              Positioned(
                top: 108,
                left: 20,
                child: CreditCardText(
                  cardNumberFormated.length > 20
                      ? cardNumberFormated.substring(0, 20)
                      : cardNumberFormated,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (enableFlipping ?? false) {
      final backSide = Transform.flip(
        key: const ValueKey('BackSide'),
        flipX: true,
        child: SizedBox(
          width: 300,
          child: AspectRatio(
            aspectRatio: 1.5789,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    topLeftColor,
                    conditionalBottomRightColor,
                  ],
                ),
                image: backgroundDecorationImage,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 24,
                    child: Container(
                      height: 50,
                      width: 300,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 84,
                    child: Container(
                      height: 36,
                      width: 200,
                      color: const Color(0xFFB3B3B3),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              cvvNumber ?? '',
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: SizedBox(
                      height: 20,
                      width: 44,
                      child: Container(
                        key: const ValueKey('CardLogoWidget'),
                        child: cardLogoWidget,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      return Transform.scale(
        scale: width == null || width! < 0
            ? 1
            : width! <= 300
                ? width! / 300
                : 1.0,
        child: AnimatedFlippingCard(
          frontSide: frontSide,
          backSide: backSide,
          controller: controller,
          disableHapticFeedBack: disableHapticFeedBack,
        ),
      );
    }

    return frontSide;
  }
}

///

class AnimatedFlippingCard extends StatefulWidget {
  ///
  const AnimatedFlippingCard({
    required this.frontSide,
    required this.backSide,
    this.disableHapticFeedBack = false,
    this.controller,
    super.key,
  });

  /// Front side of the card
  final Widget frontSide;

  /// Back side of the cards
  final Widget backSide;

  /// A boolean to enable the haptic feedback on various actions,
  /// flipping, showing balances, etc.
  final bool? disableHapticFeedBack;

  /// Controller for programmatically flipping the card
  final CreditCardController? controller;

  @override
  State<AnimatedFlippingCard> createState() => _AnimatedFlippingCardState();
}

class _AnimatedFlippingCardState extends State<AnimatedFlippingCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.medium3,
    );

    // Register the flip callback with the controller
    widget.controller?.setFlipCallback(_flip);

    // Listen to animation changes to update controller state
    _animationController.addListener(_updateControllerState);
  }

  @override
  void didUpdateWidget(AnimatedFlippingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.setFlipCallback(() {});
      widget.controller?.setFlipCallback(_flip);
    }
  }

  @override
  void dispose() {
    _animationController
      ..removeListener(_updateControllerState)
      ..dispose();
    widget.controller?.setFlipCallback(() {});
    super.dispose();
  }

  void _updateControllerState() {
    widget.controller?.setFlipState(
      isFlipped: _animationController.value >= 0.5,
    );
  }

  void _flip() {
    if (_animationController.value == 0) {
      _animationController.animateTo(1);
    } else {
      _animationController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (!widget.disableHapticFeedBack!) {
          HapticFeedback.mediumImpact();
        }

        final swipedLeft = details.velocity.pixelsPerSecond.dx < 1;

        if (swipedLeft) {
          // Do something
        }

        _flip();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          final value = _animationController.value;
          final scaleValue = value > 0.5 ? value : 1 - value;
          final clampedScale = clampDouble(scaleValue, 0.8, 1);
          final rotationValue = pi * value;

          final transformationMatrix = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..scale(clampedScale)
            ..rotateY(rotationValue);

          return Transform(
            alignment: Alignment.center,
            transform: transformationMatrix,
            child: AnimatedSwitcher(
              duration: Durations.short2,
              child: _animationController.value < 0.5
                  ? widget.frontSide
                  : widget.backSide,
            ),
          );
        },
      ),
    );
  }
}
