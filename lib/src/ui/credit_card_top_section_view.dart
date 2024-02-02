import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

///
class CreditCardTopLogo extends StatelessWidget {
  ///
  const CreditCardTopLogo({
    required this.cardType,
    required this.cardProviderLogoPosition,
    this.cardProviderLogo,
    super.key,
  });

  ///
  final CardType cardType;

  ///
  final Widget? cardProviderLogo;

  ///
  final CardProviderLogoPosition cardProviderLogoPosition;

  @override
  Widget build(BuildContext context) {
    String getCardTitle(CardType cardType) {
      switch (cardType) {
        case CardType.credit:
          return 'CREDIT';
        case CardType.debit:
          return 'DEBIT';
        case CardType.prepaid:
          return 'PREPAID';
        case CardType.giftCard:
          return 'GIFT CARD';
        case CardType.other:
          return '';
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: cardProviderLogoPosition.isLeft
          ? TextDirection.rtl
          : TextDirection.ltr,
      children: [
        Text(
          getCardTitle(cardType),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 8,
            letterSpacing: 1.5,
          ),
        ),
        cardProviderLogo ?? const SizedBox.shrink(),
      ],
    );
  }
}
