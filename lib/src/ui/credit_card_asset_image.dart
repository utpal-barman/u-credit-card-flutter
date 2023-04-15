import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/ui_constants.dart';

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
