import 'package:credit_card_ui/src/credit_card_ui.dart';
import 'package:credit_card_ui/src/ui/credit_card_text.dart';
import 'package:flutter/material.dart';

///
class CreditCardHolderNameView extends StatelessWidget {
  ///
  const CreditCardHolderNameView({
    super.key,
    required this.cardHolderFullName,
  });

  ///
  final String cardHolderFullName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      child: CreditCardText(
        cardHolderFullName.toUpperCase(),
        letterSpacing: 2,
        fontSize: 12,
      ),
    );
  }
}
