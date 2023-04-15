import 'package:credit_card_ui/src/constants/assets.dart';
import 'package:credit_card_ui/src/credit_card_ui.dart';
import 'package:credit_card_ui/src/ui/credit_card_asset_image.dart';
import 'package:flutter/material.dart';

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
