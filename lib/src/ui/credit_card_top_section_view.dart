import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_credit_card/u_credit_card.dart';

///
class CreditCardTopLogo extends StatelessWidget {
  ///
  const CreditCardTopLogo({
    required this.cardType,
    required this.cardProviderLogoPosition,
    this.cardProviderLogo,
    super.key,
    this.currencySymbol = r'$',
    this.balance = 0.0,
    this.showBalance = false,
    this.enableFlipping = false,
    this.autoHideBalance = true,
    this.disableHapticFeedback = false,
  });

  ///
  final CardType cardType;

  ///
  final Widget? cardProviderLogo;

  ///
  final CardProviderLogoPosition cardProviderLogoPosition;

  ///
  final String? currencySymbol;

  ///
  final double? balance;

  ///
  final bool? showBalance;

  ///
  final bool? enableFlipping;

  ///
  final bool? autoHideBalance;

  ///
  final bool? disableHapticFeedback;

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
        AnimatedSwitcher(
          duration: Durations.medium1,
          child: (showBalance!)
              ? _CreditCardBalanceView(
                  currencySymbol: currencySymbol,
                  balance: balance,
                  autoHideBalance: autoHideBalance,
                  disableHapticFeedBack: disableHapticFeedback,
                )
              : Text(
                  getCardTitle(cardType),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
        cardProviderLogo ?? const SizedBox.shrink(),
      ],
    );
  }
}

class _CreditCardBalanceView extends StatefulWidget {
  const _CreditCardBalanceView({
    required this.currencySymbol,
    required this.balance,
    this.autoHideBalance = true,
    this.disableHapticFeedBack = false,
  });

  final String? currencySymbol;
  final double? balance;
  final bool? autoHideBalance;
  final bool? disableHapticFeedBack;

  @override
  State<_CreditCardBalanceView> createState() => _CreditCardBalanceViewState();
}

class _CreditCardBalanceViewState extends State<_CreditCardBalanceView> {
  bool showBalance = false;
  Timer? _timer;

  Future<void> _onBalanceViewClicked() async {
    if (_timer != null) {
      return;
    }

    if (!widget.disableHapticFeedBack!) {
      await HapticFeedback.lightImpact();
    }
    setState(() {
      showBalance = !showBalance;
    });

    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showBalance = !showBalance;
        });
      }

      _timer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeOutCubic,
      duration: Durations.medium3,
      child: showBalance || !widget.autoHideBalance!
          ? SizedBox(
              width: 100,
              child: Text(
                key: const ValueKey('Balance'),
                // ignore: lines_longer_than_80_chars
                '${widget.currencySymbol}${widget.balance?.toStringAsFixed(2)}',
                //   textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : GestureDetector(
              key: const ValueKey('TapToSee'),
              onTap: _onBalanceViewClicked,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'TAP TO SEE BALANCE',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
