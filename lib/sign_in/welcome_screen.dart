import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_package_gaw_api/flutter_package_gaw_api.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage welcomeBeamPage = BeamPage(
  title: 'Welcome!',
  key: ValueKey('login'),
  type: BeamPageType.noTransition,
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
      backgroundColor: GawTheme.clearBackground,
      body: Center(
        child: SizedBox(
          height: 480,
          width: 320,
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
                hint: 'you@getawash.be',
                label: 'Email',
                controller: tecEmail,
              ),
              const SizedBox(
                height: PaddingSizes.bigPadding,
              ),
              CmsInputField(
                controller: tecPassword,
                hint: 'At least 8 characters',
                label: 'Password',
                isPasswordField: true,
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding,
              ),
              GenericButton(
                label: 'Login',
                onTap: !canLogin ? null : _login,
                loading: loading,
                color:
                    canLogin ? GawTheme.mainTint : GawTheme.unselectedMainTint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
