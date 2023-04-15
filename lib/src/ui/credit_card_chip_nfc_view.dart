import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/assets.dart';
import 'package:u_credit_card/src/ui/credit_card_asset_image.dart';

///
class CreditCardChipNfcView extends StatelessWidget {
  ///
  const CreditCardChipNfcView({
    super.key,
    required this.doesSupportNfc,
  });

  ///
  final bool doesSupportNfc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 26,
          child: CreditCardAssetImage(
            assetPath: Assets.chip,
          ),
        ),
        if (!doesSupportNfc)
          const SizedBox()
        else ...[
          const SizedBox(width: 12),
          const SizedBox(
            height: 18,
            width: 25,
            child: CreditCardAssetImage(
              assetPath: Assets.nfc,
            ),
          ),
        ],
      ],
    );
  }
}
