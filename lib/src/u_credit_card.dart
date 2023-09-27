import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/ui_constants.dart';
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
    super.key,
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.validThru,
    this.validFrom,
    this.topLeftColor = Colors.purple,
    this.bottomRightColor,
    this.doesSupportNfc = true,
    this.scale = 1.0,
    this.placeNfcIconAtTheEnd = false,
    this.cardType = CardType.credit,
    this.creditCardType,
    this.cardProviderLogo,
    this.cardProviderLogoPosition = CardProviderLogoPosition.right,
    this.backgroundDecorationImage,
    this.showValidFrom = true,
    this.showValidThru = true,
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
  final double scale;

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

  @override
  Widget build(BuildContext context) {
    final cardNumberMasked = CreditCardHelper.maskCreditCardNumber(
      cardNumber.replaceAll(' ', '').replaceAll('-', ''),
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
      cardNumber: cardNumberMasked,
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
          cardNumber: cardNumberMasked,
        ),
        package: UiConstants.packageName,
      );
    }

    return Transform.scale(
      scale: scale,
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
                  left: 16,
                  top: 16,
                  child: SizedBox(
                    height: 32,
                    width: 268,
                    child: CreditCardTopLogo(
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
                        key: ValueKey(cardNumberMasked),
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
                    cardNumberMasked.length > 20
                        ? cardNumberMasked.substring(0, 20)
                        : cardNumberMasked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
