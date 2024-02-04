import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/sign_in/sign_in_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class ConfirmLogoutDialog extends ConsumerStatefulWidget {
  const ConfirmLogoutDialog({
    super.key,
  });

  @override
  ConsumerState<ConfirmLogoutDialog> createState() =>
      ConfirmLogoutDialogState();
}

class ConfirmLogoutDialogState extends ConsumerState<ConfirmLogoutDialog>
    with ScreenStateMixin {
  static Future<void> logout() async {
    LocalStorageUtil.setTokens(null, null);

    mainRouter.beamToNamed(SignInScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 180,
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.smallPadding,
              vertical: PaddingSizes.mainPadding,
            ),
            child: MainText(
              "Are you sure you want to log out?",
              textStyleOverride: TextStyles.titleStyle.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.smallPadding,
              vertical: PaddingSizes.smallPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GenericButton(
                    label: "Logout",
                    color: GawTheme.error,
                    onTap: logout,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: GawTheme.mainTintText,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                Expanded(
                  child: GenericButton(
                    loading: loading,
                    label: "Cancel",
                    outline: true,
                    color: GawTheme.clearBackground,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: GawTheme.text,
                    ),
                    onTap: () {
                      if (loading) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
