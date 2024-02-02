import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/ui_constants.dart';

///
class CreditCardAssetImage extends StatelessWidget {
  ///
  const CreditCardAssetImage({
    required this.assetPath,
    super.key,
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
