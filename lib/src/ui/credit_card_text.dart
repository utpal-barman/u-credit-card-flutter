import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/ui_constants.dart';

///
class CreditCardText extends StatelessWidget {
  ///
  const CreditCardText(
    this.text, {
    super.key,
    this.letterSpacing = 3.2,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
  });

  ///
  final String text;

  ///
  final double letterSpacing;

  ///
  final double fontSize;

  ///
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: UiConstants.fontFamily,
        package: UiConstants.packageName,
      ),
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
  }
}
