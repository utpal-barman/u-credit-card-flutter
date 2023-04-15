import 'package:flutter/material.dart';
import 'package:u_credit_card/src/ui/credit_card_text.dart';

///
class CreditCardValidityView extends StatelessWidget {
  ///
  const CreditCardValidityView({
    super.key,
    required this.validFromMasked,
    required this.validThruMasked,
  });

  ///
  final String? validFromMasked;

  ///
  final String validThruMasked;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(width: 24),
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
    );
  }
}
