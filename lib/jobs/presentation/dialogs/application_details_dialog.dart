import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/core/widgets/maps/basic_map.dart';
import 'package:flutter_gaw_cms/jobs/presentation/widgets/job_info_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApplicationDetailsDialog extends ConsumerStatefulWidget {
  final JobApplication application;

  const ApplicationDetailsDialog({
    super.key,
    required this.application,
  });

  @override
  ConsumerState<ApplicationDetailsDialog> createState() =>
      _ApplicationDetailsDialogState();
}

class _ApplicationDetailsDialogState
    extends ConsumerState<ApplicationDetailsDialog> with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.smallPadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: BasicMap(
                      selectedAddressPosition: LatLng(
                        widget.application.address.latitude ?? 0,
                        widget.application.address.longitude ?? 0,
                      ),
                      startPosition: LatLng(
                        widget.application.job.address.latitude ?? 0,
                        widget.application.job.address.longitude ?? 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: PaddingSizes.bigPadding,
                    ),
                    child: Row(
                      children: [
                        Visibility(
                          visible: widget.application.job.selectedWashers <
                              widget.application.job.maxWashers,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: PaddingSizes.mainPadding,
                            ),
                            child: GenericButton(
                              onTap: () {
                                setLoading(true);
                                JobsApi.approveApplication(
                                        id: widget.application.id!)
                                    .then((_) {
                                  Navigator.pop(context);
                                  ref.invalidate(jobsProvider);
                                }).catchError((error) {
                                  ExceptionHandler.show(error);
                                }).whenComplete(() => setLoading(false));
                              },
                              label: 'Approve',
                              textStyleOverride: TextStyles.mainStyle.copyWith(
                                color: GawTheme.clearText,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        GenericButton(
                          label: 'Deny',
                          outline: true,
                          textColor: GawTheme.unselectedText,
                          onTap: () {
                            setLoading(true);
                            JobsApi.denyApplication(id: widget.application.id!)
                                .then((_) {
                              Navigator.pop(context);
                              ref.invalidate(jobsProvider);
                            }).catchError((error) {
                              ExceptionHandler.show(error);
                            }).whenComplete(() => setLoading(false));
                          },
                          color: GawTheme.clearText,
                          textStyleOverride: TextStyles.mainStyle.copyWith(
                            color: GawTheme.text,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.bigPadding,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingSizes.smallPadding,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MainText(
                            widget.application.job.title ?? '',
                            textStyleOverride: TextStyles.titleStyle.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SelectedWashersWidget(
                          selectedWashers:
                              widget.application.job.selectedWashers,
                          maxWashers: widget.application.job.maxWashers,
                        ),
                      ],
                    ),
                  ),
                  const GawDivider(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: PaddingSizes.bigPadding,
                      left: PaddingSizes.mainPadding +
                          PaddingSizes.extraBigPadding,
                    ),
                    child: MainText(
                      'DATE & TIME',
                      textStyleOverride: TextStyles.mainStyle.copyWith(
                        color: GawTheme.unselectedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  _InfoRow(
                    leading: const SvgIcon(
                      PixelPerfectIcons.timeIndicator,
                      color: GawTheme.secondaryTint,
                    ),
                    first: GawDateUtil.formatDate(
                      GawDateUtil.fromApi(widget.application.job.startTime),
                    ),
                    last: GawDateUtil.formatTimeInterval(
                      GawDateUtil.fromApi(widget.application.job.startTime),
                      GawDateUtil.fromApi(widget.application.job.endTime),
                    ),
                    isTime: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: PaddingSizes.bigPadding,
                      left: PaddingSizes.mainPadding +
                          PaddingSizes.extraBigPadding,
                    ),
                    child: MainText(
                      'LOCATION',
                      textStyleOverride: TextStyles.mainStyle.copyWith(
                        color: GawTheme.unselectedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  _InfoRow(
                    leading: const SvgIcon(
                      PixelPerfectIcons.placeIndicator,
                      color: GawTheme.mainTint,
                    ),
                    first: widget.application.address.formattedStreetAddress(),
                    last: widget.application.address.shortAddress(),
                  ),
                  const SizedBox(
                    height: PaddingSizes.bigPadding,
                  ),
                  _NoTransportCosts(
                    noTravelCosts: widget.application.noTravelCosts,
                  ),
                  const SizedBox(
                    height: PaddingSizes.extraBigPadding,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoTransportCosts extends StatelessWidget {
  const _NoTransportCosts({super.key, this.noTravelCosts = false});

  final bool noTravelCosts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: BigCheckBox(
        label: noTravelCosts
            ? 'Is paying for transport'
            : 'Is not paying for transport',
        value: noTravelCosts,
      ),
    );
  }
}

class FractionBadge extends StatelessWidget {
  final String numerator;
  final String denominator;

  const FractionBadge({
    Key? key,
    required this.numerator,
    required this.denominator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: GawTheme.clearBackground, // Change this color to match your UI
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: GawTheme.unselectedText.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          const SvgIcon(PixelPerfectIcons.washers, color: GawTheme.text),
          const SizedBox(
            width: 2,
          ),
          Text(
            '$numerator/$denominator',
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: GawTheme.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Widget leading;

  final String first;

  final String last;

  final bool isTime;

  const _InfoRow({
    super.key,
    required this.leading,
    required this.first,
    required this.last,
    this.isTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: PaddingSizes.smallPadding,
        bottom: PaddingSizes.extraSmallPadding,
        left: PaddingSizes.extraSmallPadding,
      ),
      child: Row(
        children: [
          leading,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.mainPadding,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: Borders.mainSide,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: PaddingSizes.smallPadding,
                      ),
                      child: MainText(
                        first,
                        textStyleOverride: TextStyles.mainStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    isTime
                        ? const SizedBox(width: PaddingSizes.mainPadding)
                        : const SizedBox.shrink(),
                    MainText(
                      last,
                      textStyleOverride: TextStyles.mainStyle.copyWith(
                        color:
                            !isTime ? GawTheme.unselectedText : GawTheme.text,
                        fontWeight: !isTime ? FontWeight.w500 : FontWeight.w400,
                        fontSize: !isTime ? 13 : 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
