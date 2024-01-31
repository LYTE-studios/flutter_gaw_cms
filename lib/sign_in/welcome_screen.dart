import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_gaw_cms/sign_in/forgot_password_screen.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage welcomeBeamPage = BeamPage(
  title: 'Welcome!',
  key: ValueKey('login'),
  child: WelcomeScreen(),
);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const String route = '/sign-in/welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with ScreenStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late final TextEditingController tecEmail = TextEditingController()
    ..addListener(_validate);
  late final TextEditingController tecPassword = TextEditingController()
    ..addListener(_validate);

  bool canLogin = false;

  void _login() {
    if (!canLogin) {
      return;
    }

    setLoading(true);
    AuthenticationApi.credentialsLogin(
      request: LoginRequest(
        (b) => b
          ..email = tecEmail.text
          ..password = tecPassword.text,
      ),
    ).then((response) {
      setLoading(false);
      mainRouter.beamToNamed(DashboardScreen.route);
    }).catchError((error, stackTrace) {
      setLoading(false);
      ExceptionHandler.show(
        error,
        stackTrace: stackTrace,
        context: _scaffoldKey.currentContext,
        message: 'Are you sure those credentials are correct?',
      );
    });
  }

  void _validate() {
    bool valid = false;
    if (tecEmail.text.isNotEmpty && tecPassword.text.isNotEmpty) {
      valid = true;
    }

    if (valid != canLogin) {
      setState(() {
        canLogin = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GawTheme.clearText,
      body: Center(
        child: Container(
          height: 360,
          width: 420,
          decoration: BoxDecoration(
            color: GawTheme.clearText,
            boxShadow: const [
              Shadows.topSheetShadow,
            ],
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.extraBigPadding,
              vertical: PaddingSizes.extraBigPadding + PaddingSizes.bigPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  'Welcome back!',
                  alignment: TextAlign.start,
                  textStyleOverride: TextStyles.mainStyleTitle.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(
                  height: PaddingSizes.extraBigPadding,
                ),
                CmsInputField(
                  label: 'Email',
                  controller: tecEmail,
                ),
                const SizedBox(
                  height: PaddingSizes.bigPadding,
                ),
                CmsInputField(
                  controller: tecPassword,
                  label: 'Password',
                  isPasswordField: true,
                  onSubmitted: _login,
                ),
                const SizedBox(
                  height: PaddingSizes.smallPadding,
                ),
                Row(
                  children: [
                    const Spacer(),
                    ColorlessInkWell(
                      onTap: () {
                        signInRouter.beamToNamed(ForgotPasswordScreen.route);
                      },
                      child: const Text(
                        'Forgot password?',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: GawTheme.mainTint,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GenericButton(
                  label: 'Login',
                  onTap: !canLogin ? null : _login,
                  loading: loading,
                  color: canLogin
                      ? GawTheme.mainTint
                      : GawTheme.unselectedMainTint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
