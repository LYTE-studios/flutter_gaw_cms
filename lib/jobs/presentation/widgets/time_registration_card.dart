import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class TimeRegistrationCard extends StatelessWidget {
  final TimeRegistration? timeRegistration;

  final Washer? washer;

  const TimeRegistrationCard({
    super.key,
    this.timeRegistration,
    this.washer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        PaddingSizes.mainPadding,
      ),
      child: Container(
        height: 221,
        width: 256,
        padding: const EdgeInsets.all(PaddingSizes.extraBigPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: GawTheme.clearText,
          border: Border.all(color: GawTheme.background),
          boxShadow: const [
            Shadows.heavyShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 36,
              child: ProfileRowItem(
                fixedWidth: 156,
                initials: washer?.initials,
                imageUrl: washer?.profilePictureUrl,
                firstName: washer?.firstName,
                lastName: washer?.lastName,
              ),
            ),
            const GawDivider(),
            Expanded(
              child: timeRegistration == null
                  ? Center(
                      child: MainText(
                        'Awaiting time registration',
                        textStyleOverride: TextStyles.mainStyle.copyWith(
                          color: GawTheme.unselectedText,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: PaddingSizes.mainPadding,
                        ),
                        Row(
                          children: [
                            const MainText(
                              "From: ",
                              color: GawTheme.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            MainText(
                              GawDateUtil.formatTimeString(
                                GawDateUtil.fromApi(
                                  timeRegistration!.startTime!,
                                ),
                              ),
                              color: GawTheme.mainTint,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 42),
                            const MainText(
                              "Until: ",
                              color: GawTheme.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            MainText(
                              GawDateUtil.formatTimeString(
                                GawDateUtil.fromApi(
                                  timeRegistration!.endTime!,
                                ),
                              ),
                              color: GawTheme.mainTint,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: PaddingSizes.mainPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border.fromBorderSide(
                                    Borders.lightSide,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    PaddingSizes.smallPadding,
                                  ),
                                  child: Image.network(
                                    FormattingUtil.formatUrl(
                                          timeRegistration?.washerSignatureUrl,
                                        ) ??
                                        '',
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (context, _, __) {
                                      return Center(
                                        child: MainText(
                                          'Signature not found',
                                          textStyleOverride:
                                              TextStyles.mainStyle.copyWith(
                                            color: GawTheme.error,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: PaddingSizes.smallPadding,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border.fromBorderSide(
                                    Borders.lightSide,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    PaddingSizes.smallPadding,
                                  ),
                                  child: Image.network(
                                    FormattingUtil.formatUrl(
                                          timeRegistration
                                              ?.customerSignatureUrl,
                                        ) ??
                                        '',
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (context, _, __) {
                                      return Center(
                                        child: MainText(
                                          'Signature not found',
                                          textStyleOverride:
                                              TextStyles.mainStyle.copyWith(
                                            color: GawTheme.error,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
