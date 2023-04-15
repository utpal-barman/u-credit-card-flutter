import 'package:credit_card_ui/src/constants/ui_constants.dart';
import 'package:flutter/material.dart';

///
class CreditCardAssetImage extends StatelessWidget {
  ///
  const CreditCardAssetImage({
    super.key,
    required this.assetPath,
  });

  ///
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      package: UiConstants.packageName,
      fit: BoxFit.contain,
    );
  }
}
