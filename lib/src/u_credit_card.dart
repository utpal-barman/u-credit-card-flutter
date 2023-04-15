import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/ui_constants.dart';
import 'package:u_credit_card/src/ui/credit_card_chip_nfc_view.dart';
import 'package:u_credit_card/src/ui/credit_card_holder_name_view.dart';
import 'package:u_credit_card/src/ui/credit_card_text.dart';
import 'package:u_credit_card/src/ui/credit_card_validity_view.dart';
import 'package:u_credit_card/src/utils/credit_card_helper.dart';

/// Creates Credit Card UI
class CreditCardUi extends StatelessWidget {
  /// Creates Credit Card UI
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
  }) : assert(
          cardNumber.length >= 4,
          'Card no. must be at least 4 of length, found  ${cardNumber.length}',
        );

  /// Full Name of the Card Holder
  final String cardHolderFullName;

  /// Full credit card number, can support asterisks
  final String cardNumber;

  /// Enter valid from date of the card month and year like mm/yy,
  ///
  /// Example 01/23, here 01 means month January & 23 means year 2023
  /// Optional field, can be skipped
  final String? validFrom;

  /// Enter validity of the card month and year like mm/yy,
  ///
  /// Example 01/28, here 01 means month January & 28 means year 2028
  final String validThru;

  /// Top Left Color for the Gradient,
  /// by default it's `Colors.purple`
  ///
  /// Tip: Avoid light colors, because texts are now white
  final Color topLeftColor;

  /// Bottom Left Color for the Gradient,
  /// by default it's deeper version of `topLeftColor`
  ///
  /// Tip: Avoid light colors, because texts are now white
  final Color? bottomRightColor;

  /// Shows a NFC icon to tell user if the card supports NFC feature.
  ///
  /// By default it is `true`
  final bool doesSupportNfc;

  /// Can scale the credit card
  ///
  /// if you want reduce the size,
  /// set the value less than 1, else set greater than 1
  ///
  /// By default the value is 1.0
  final double scale;

  @override
  Widget build(BuildContext context) {
    final cardNumberMasked = CreditCardHelper.maskCreditCardNumber(
      cardNumber,
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
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 64,
                  child: CreditCardChipNfcView(
                    doesSupportNfc: doesSupportNfc,
                  ),
                ),
                Positioned(
                  top: 138,
                  left: 20,
                  child: CreditCardValidityView(
                    validFromMasked: validFromMasked,
                    validThruMasked: validThruMasked,
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
                        child: Image.asset(
                          CreditCardHelper.getCardLogo(cardNumberMasked),
                          package: UiConstants.packageName,
                        ),
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
                  child: CreditCardText(cardNumberMasked),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
