import 'package:flutter/material.dart';
import 'package:u_credit_card/src/constants/assets.dart';
import 'package:u_credit_card/src/ui/credit_card_asset_image.dart';

///
class CreditCardChipNfcView extends StatelessWidget {
  ///
  const CreditCardChipNfcView({
    required this.doesSupportNfc,
    required this.placeNfcIconAtTheEnd,
    super.key,
  });

  ///
  final bool doesSupportNfc;

  ///
  final bool placeNfcIconAtTheEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 264,
      child: Row(
        children: [
          ...[
            const SizedBox(width: 12),
            const SizedBox(
              height: 26,
              child: CreditCardAssetImage(
                assetPath: Assets.chip,
              ),
            ),
          ],
          if (placeNfcIconAtTheEnd) const Spacer(),
          if (!doesSupportNfc)
            const SizedBox.shrink()
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
      ),
    );
  }
}
