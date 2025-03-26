import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class TimeRegistrationCard extends ConsumerStatefulWidget {
  final Job job;

  final TimeRegistration? timeRegistration;

  final Worker? washer;

  final Function()? onEdit;

  const TimeRegistrationCard({
    super.key,
    required this.job,
    this.timeRegistration,
    this.washer,
    this.onEdit,
  });

  @override
  ConsumerState<TimeRegistrationCard> createState() =>
      _TimeRegistrationCardState();
}

class _TimeRegistrationCardState extends ConsumerState<TimeRegistrationCard>
    with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        PaddingSizes.mainPadding,
      ),
      child: ColorlessInkWell(
        onTap: () {
          DialogUtil.show(
            dialog: TimeRangePickerDialog(
              title: widget.washer?.getFullName(),
              initialStart:
                  GawDateUtil.tryFromApi(widget.timeRegistration?.startTime),
              initialEnd:
                  GawDateUtil.tryFromApi(widget.timeRegistration?.endTime),
              onSubmit: (DateTime startTime, DateTime endTime) {
                setLoading(true);

                JobsApi.createTimeRegistration(
                  userId: widget.washer!.id,
                  request: TimeRegistrationRequest(
                    (b) => b
                      ..jobId = widget.job.id
                      ..startTime = GawDateUtil.toApi(startTime)
                      ..endTime = GawDateUtil.toApi(endTime)
                      ..breakTime = 0,
                  ),
                ).catchError((error) {
                  ExceptionHandler.show(error);
                }).whenComplete(() {
                  widget.onEdit?.call();
                  setLoading(false);
                });
              },
            ),
            context: context,
          );
        },
        child: LoadingSwitcher(
          loading: loading,
          child: Container(
            height: 256,
            width: 256,
            clipBehavior: Clip.none,
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
                ColorlessInkWell(
                  onTap: () {
                    String value = widget.washer?.ssn ??
                        widget.timeRegistration?.worker?.ssn ??
                        '';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        elevation: 0,
                        duration: const Duration(
                          seconds: 1,
                        ),
                        backgroundColor: Colors.transparent,
                        content: BasicSnackBar(
                          title: 'Copied!',
                          description: '$value got copied to your clipboard',
                        ),
                      ),
                    );

                    Clipboard.setData(
                      ClipboardData(
                        text: value,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 36,
                    child: ProfileRowItem(
                      fixedWidth: 156,
                      initials: widget.washer?.initials,
                      imageUrl: widget.washer?.profilePictureUrl,
                      firstName: widget.washer?.firstName,
                      lastName: widget.washer?.lastName,
                    ),
                  ),
                ),
                const GawDivider(),
                Expanded(
                  child: widget.timeRegistration == null
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      widget.timeRegistration!.startTime!,
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
                                      widget.timeRegistration!.endTime!,
                                    ),
                                  ),
                                  color: GawTheme.mainTint,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: PaddingSizes.smallPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const MainText(
                                  "Break time: ",
                                  color: GawTheme.text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                MainText(
                                  GawDateUtil.formatTimeString(
                                    DateTime(
                                      0,
                                      0,
                                      0,
                                      0,
                                      widget.timeRegistration?.breakTime ?? 0,
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
                                              widget.timeRegistration
                                                  ?.workerSignatureUrl,
                                            ) ??
                                            '',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, _, __) {
                                          return Center(
                                            child: MainText(
                                              'Edited by admin',
                                              textStyleOverride:
                                                  TextStyles.mainStyle.copyWith(
                                                color: GawTheme.secondaryTint,
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
                                              widget.timeRegistration
                                                  ?.customerSignatureUrl,
                                            ) ??
                                            '',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, _, __) {
                                          return Center(
                                            child: MainText(
                                              'Edited by admin',
                                              textStyleOverride:
                                                  TextStyles.mainStyle.copyWith(
                                                color: GawTheme.secondaryTint,
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
        ),
      ),
    );
  }
}
