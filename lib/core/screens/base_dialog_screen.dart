import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseDialogScreen extends StatelessWidget {
  final Object? exception;

  final StackTrace? stackTrace;

  final String? title;

  final String? description;

  const BaseDialogScreen({
    super.key,
    this.exception,
    this.stackTrace,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GawTheme.mainTint,
      body: InkWell(
        onTap: () {
          Beamer.of(context).popRoute();
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              MainText(
                title ?? 'Ooops...',
                textStyleOverride: TextStyles.titleStyle.copyWith(
                  color: GawTheme.mainTintText,
                  fontWeight: FontWeight.w900,
                  fontSize: 42,
                ),
              ),
              const SizedBox(
                height: PaddingSizes.bigPadding,
              ),
              SizedBox(
                width: 240,
                child: Center(
                  child: MainText(
                    description ?? 'Something went wrong, try again later!',
                    alignment: TextAlign.center,
                    textStyleOverride: TextStyles.titleStyle.copyWith(
                      color: GawTheme.mainTintText,
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: PaddingSizes.extraBigPadding * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingSizes.bigPadding,
                  vertical: PaddingSizes.extraBigPadding,
                ),
                child: SafeArea(
                  top: false,
                  bottom: true,
                  child: SizedBox(
                    height: 48,
                    width: 180,
                    child: GenericButton(
                      label: 'Go back',
                      color: GawTheme.clearBackground,
                      textStyleOverride: TextStyles.titleStyle.copyWith(
                        color: GawTheme.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
