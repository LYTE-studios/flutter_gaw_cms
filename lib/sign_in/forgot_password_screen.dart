import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_gaw_cms/sign_in/verify_code_screen.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage forgotPasswordBeamPage = BeamPage(
  title: 'Forgot password',
  key: ValueKey('forgot-password'),
  type: BeamPageType.slideRightTransition,
  child: ForgotPasswordScreen(),
);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String route = '/sign-in/welcome/forgot_password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with ScreenStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool valid = false;

  late final TextEditingController tecEmail = TextEditingController()
    ..addListener(validate);

  void validate() {
    bool newValid = tecEmail.text.isNotEmpty;

    if (newValid != valid) {
      setState(() {
        valid = newValid;
      });
    }
  }

  void onSendEmail(ctx) {
    if (!valid || loading) {
      return;
    }

    setLoading(true);

    AuthenticationApi.sendPasswordResetEmail(
      request: EmailRequest(
        (b) => b..email = tecEmail.text,
      ),
    ).then((value) {
      setLoading(false);
      signInRouter.beamToNamed(VerifyCodeScreen.route, data: tecEmail.text);
    }).catchError((error) {
      setLoading(false);

      ExceptionHandler.show(
        error,
        context: context,
        message: 'Are you sure the given credentials are correct?',
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
                'Enter the email associated with your account. We will send you an email with the instructions to reset your password.',
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
                hint: 'you@getawash.be',
                label: 'Email',
                controller: tecEmail,
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding,
              ),
              GenericButton(
                label: 'Send reset code',
                onTap: !valid ? null : () => onSendEmail(context),
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
