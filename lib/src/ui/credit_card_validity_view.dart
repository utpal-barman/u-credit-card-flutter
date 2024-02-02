import 'package:flutter/material.dart';
import 'package:u_credit_card/src/ui/credit_card_text.dart';

///
class CreditCardValidityView extends StatelessWidget {
  ///
  const CreditCardValidityView({
    required this.validFromMasked,
    required this.validThruMasked,
    this.showValidFrom = true,
    this.showValidThru = true,
    super.key,
  });

  ///
  final String? validFromMasked;

  ///
  final String validThruMasked;

  /// Determines whether to show the "Valid From" segment on the card.
  ///
  /// If set to `true`, the "Valid From" segment will be displayed.
  /// If set to `false`, it will be hidden.
  /// The default value is `true`.
  final bool showValidFrom;

  /// Determines whether to show the "Valid Thru" segment on the card.
  ///
  /// If set to `true`, the "Valid Thru" segment will be displayed.
  /// If set to `false`, it will be hidden.
  /// The default value is `true`.
  final bool showValidThru;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility.maintain(
          visible: showValidFrom,
          child: Row(
            children: [
              const SizedBox(
                width: 24,
                child: Text(
                  'VALID FROM',
                  style: TextStyle(
                    color: Color.fromARGB(255, 200, 200, 200),
                    fontSize: 5,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (validFromMasked == null)
                const SizedBox(width: 38)
              else
                CreditCardText(
                  validFromMasked!,
                  letterSpacing: 2,
                  fontSize: 9,
                ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Visibility.maintain(
          visible: showValidThru,
          child: Row(
            children: [
              const SizedBox(
                width: 24,
                child: Text(
                  'VALID THRU',
                  style: TextStyle(
                    color: Color.fromARGB(255, 200, 200, 200),
                    fontSize: 5,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CreditCardText(
                validThruMasked,
                letterSpacing: 2,
                fontSize: 9,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
