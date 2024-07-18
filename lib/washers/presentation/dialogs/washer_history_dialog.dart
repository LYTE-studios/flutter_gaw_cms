import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/application_details_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WasherHistoryDialog extends StatefulWidget {
  final String washerId;

  const WasherHistoryDialog({
    super.key,
    required this.washerId,
  });

  @override
  State<WasherHistoryDialog> createState() => _WasherDetailsFormState();
}

class _WasherDetailsFormState extends State<WasherHistoryDialog>
    with ScreenStateMixin {
  int itemCount = 25;

  int page = 1;

  ApplicationListResponse? applicationsListResponse;

  void loadData({
    int? page,
    int? itemCount,
  }) {
    setLoading(true);

    setData(() {
      this.page = page ?? this.page;
      this.itemCount = itemCount ?? this.itemCount;
    });

    JobsApi.getHistoryForWasher(
      widget.washerId,
      page: page ?? 1,
      itemCount: itemCount ?? 25,
    ).then((response) {
      setData(() {
        applicationsListResponse = response;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  @override
  void initState() {
    Future(() {
      loadData(
        page: page,
        itemCount: itemCount,
      );
    });
    super.initState();
  }

  void onSelected(JobApplication application) {
    DialogUtil.show(
      dialog: ApplicationDetailsDialog(
        application: application,
      ),
      context: context,
    ).then((_) => loadData());
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 760,
      width: 960,
      dismissable: false,
      child: GenericListView(
        minWidth: 960,
        loading: loading,
        canDelete: false,
        title: 'Job history',
        valueName: LocaleKeys.jobs.tr().toLowerCase(),
        onEditItemCount: (int index) {
          loadData(itemCount: index, page: page);
        },
        onChangePage: (int index) {
          loadData(itemCount: itemCount, page: index);
        },
        page: page,
        itemsPerPage: itemCount,
        totalItems: applicationsListResponse?.total,
        header: BaseListHeader(
          selected: false,
          items: {
            const BaseHeaderItem(
              label: 'Job title',
            ): ListUtil.lColumn,
            const BaseHeaderItem(
              label: 'Date',
            ): ListUtil.lColumn,
            const BaseHeaderItem(
              label: 'Time',
            ): ListUtil.lColumn,
            const BaseHeaderItem(
              label: '  ',
            ): ListUtil.mColumn,
          },
        ),
        rows: applicationsListResponse?.applications.map(
              (application) {
                DateTime startTime =
                    GawDateUtil.fromApi(application.job.startTime);

                DateTime endTime = GawDateUtil.fromApi(application.job.endTime);

                return BaseListItem(
                  items: {
                    TextRowItem(
                      value: application.job.title,
                      fixedWidth: ListUtil.mColumn,
                    ): ListUtil.lColumn,
                    TextRowItem(
                      value: GawDateUtil.formatFullDate(startTime),
                      fixedWidth: ListUtil.mColumn,
                    ): ListUtil.lColumn,
                    TextRowItem(
                      value: GawDateUtil.formatTimeInterval(startTime, endTime),
                      fixedWidth: ListUtil.mColumn,
                    ): ListUtil.lColumn,
                    BaseRowItem(
                      child: ColorlessInkWell(
                        onTap: () {
                          onSelected(application);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.all(PaddingSizes.mainPadding),
                          child: Container(
                            height: 32,
                            width: 128,
                            decoration: BoxDecoration(
                              color: GawTheme.clearText,
                              borderRadius: BorderRadius.circular(4),
                              border: const Border.fromBorderSide(
                                Borders.lightSide,
                              ),
                            ),
                            child: const IntrinsicWidth(
                              child: IntrinsicWidth(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: PaddingSizes.smallPadding,
                                    ),
                                    child: MainText(
                                      'View job',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ): ListUtil.mColumn,
                  },
                );
              },
            ).toList() ??
            [],
      ),
    );
  }
}
