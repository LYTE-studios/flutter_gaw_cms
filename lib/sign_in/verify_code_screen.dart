import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

BeamPage verifyCodeBeamPage(String email) {
  return BeamPage(
    title: 'Verify Code',
    key: const ValueKey('verify-code'),
    type: BeamPageType.slideLeftTransition,
    child: VerifyCodeScreen(email: email),
  );
}

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.email});

  static const String route = '/sign-in/welcome/forgot_password/verify_code';
  final String email;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with ScreenStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool valid = false;

  late final TextEditingController tecCode = TextEditingController()
    ..addListener(validate);

  void validate() {
    bool newValid = tecCode.text.isNotEmpty;

    if (newValid != valid) {
      setState(() {
        valid = newValid;
      });
    }
  }

  void onVerifyCode(ctx) {
    if (!valid || loading) {
      return;
    }

    setLoading(true);

    AuthenticationApi.verifyPasswordResetCode(
      request: CodeVerificationRequest(
        (b) => b
          ..email = widget.email
          ..code = tecCode.text,
      ),
    ).then((value) {
      setLoading(false);
      signInRouter.beamToNamed(
          '/sign-in/welcome/forgot-password/reset-password/${tecCode.text}/${value!.token}');
    }).catchError((error) {
      setLoading(false);

      ExceptionHandler.show(
        error,
        context: context,
        message: 'Are you sure the given code is correct?',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                'To verify your identity, please enter the code we sent to your email address.',
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
                hint: '012345',
                label: 'Code',
                controller: tecCode,
                onSubmitted: () => onVerifyCode(context),
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding,
              ),
              GenericButton(
                label: 'Verify code',
                onTap: !valid ? null : () => onVerifyCode(context),
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
