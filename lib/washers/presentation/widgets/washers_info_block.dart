import 'package:flutter/material.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WashersInfoBlock extends StatelessWidget {
  final Washer washer;

  const WashersInfoBlock({
    required this.washer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: GawTheme.border, width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MainText('TODO'),
                  ),
                  const SizedBox(width: PaddingSizes.mainPadding),
                  MainText(
                    washer.firstName,
                    color: GawTheme.specialText,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: PaddingSizes.mainPadding),
      ],
    );
  }
}
