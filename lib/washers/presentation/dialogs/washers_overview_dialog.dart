import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WashersOverviewDialog extends ConsumerWidget {
  final Worker washer;

  const WashersOverviewDialog({
    super.key,
    required this.washer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: [
            TextButton(
              child: const Row(
                children: [
                  SvgIcon(
                    PixelPerfectIcons.arrowBack,
                  ),
                  SizedBox(width: 15),
                  MainText("Back"),
                ],
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 68),
            Text(washer.firstName ?? ''),
            const SizedBox(height: 54),
            Row(
              children: [
                const MainText(
                  "From:",
                  color: GawTheme.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                MainText(
                  // TODO
                  '',
                  color: GawTheme.mainTint,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 42),
                const MainText(
                  "Until:",
                  color: GawTheme.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                MainText(
                  // TODO
                  '',
                  color: GawTheme.mainTint,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 66),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 450,
                  height: 255,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: GawTheme.toolBarItem),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text("Washer Signature"),
                ),
                Container(
                  width: 450,
                  height: 255,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: GawTheme.toolBarItem),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text("Client Signature"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
