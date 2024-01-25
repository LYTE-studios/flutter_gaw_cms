import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/sign_in/welcome_screen.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

BeamPage resetPasswordBeamPage(String code, String token) {
  return BeamPage(
    title: 'Reset Passord',
    key: const ValueKey('reset-password'),
    type: BeamPageType.slideRightTransition,
    child: PasswordResetScreen(code: code, token: token),
  );
}

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen(
      {super.key, required this.code, required this.token});

  static const String route =
      '/sign-in/welcome/forgot-password/reset-password/:code/:token';
  final String code;
  final String token;

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen>
    with ScreenStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool valid = false;

  late final TextEditingController tecPassword = TextEditingController()
    ..addListener(validate);
  late final TextEditingController tecPasswordCheck = TextEditingController()
    ..addListener(validate);

  void validate() {
    bool hasEmpty = <String>[
      tecPassword.text,
      tecPasswordCheck.text,
    ].map((e) => e.isEmpty).contains(true);
    bool newValid = !hasEmpty && tecPassword.text == tecPasswordCheck.text;

    if (newValid != valid) {
      setState(() {
        valid = newValid;
      });
    }
  }

  void onResetPassword(ctx) {
    if (!valid || loading) {
      return;
    }

    setLoading(true);

    AuthenticationApi.resetPassword(
      request: PasswordResetRequest(
        (b) => b
          ..code = widget.code
          ..token = widget.token
          ..password = tecPassword.text,
      ),
    ).then((value) {
      setLoading(false);
      signInRouter.beamToNamed(
        WelcomeScreen.route,
      );
    }).catchError((error) {
      setLoading(false);

      ExceptionHandler.show(
        error,
        context: context,
        message: 'Uh-oh? Something went wrong.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print('yes');
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GawTheme.clearBackground,
      body: Center(
        child: SizedBox(
          height: 480,
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderBackButton(
                color: GawTheme.text,
                goBack: () => signInRouter.beamBack(),
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding,
              ),
              MainText(
                'Reset your password',
                alignment: TextAlign.start,
                textStyleOverride: TextStyles.mainStyleTitle.copyWith(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: PaddingSizes.bigPadding,
              ),
              MainText(
                'Choose your new password.',
                alignment: TextAlign.start,
                textStyleOverride: TextStyles.mainStyleTitle.copyWith(
                  color: Colors.black87.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding + 8,
              ),
              CmsInputField(
                hint: 'Choose Password',
                label: 'Password',
                controller: tecPassword,
                isPasswordField: true,
              ),
              const SizedBox(
                height: PaddingSizes.bigPadding,
              ),
              CmsInputField(
                hint: 'Choose Password',
                label: 'Password',
                controller: tecPasswordCheck,
                isPasswordField: true,
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding,
              ),
              GenericButton(
                label: 'Reset Password',
                onTap: !valid ? null : () => onResetPassword(context),
                loading: loading,
                color: valid ? GawTheme.mainTint : GawTheme.unselectedMainTint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
