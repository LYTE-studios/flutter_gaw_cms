import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_details_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CustomerHistoryDialog extends StatefulWidget {
  final String customerId;

  const CustomerHistoryDialog({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerHistoryDialog> createState() => CustomerHistoryDialogState();
}

class CustomerHistoryDialogState extends State<CustomerHistoryDialog>
    with ScreenStateMixin {
  int itemCount = 25;

  int page = 1;

  JobListResponse? jobListResponse;

  @override
  Future<void> loadData({
    int? page,
    int? itemCount,
  }) async {
    setLoading(true);

    setState(() {
      this.page = page ?? this.page;
      this.itemCount = itemCount ?? this.itemCount;
    });

    JobsApi.getHistoryForCustomer(
      widget.customerId,
      page: page ?? 1,
      itemCount: itemCount ?? 25,
    ).then((response) {
      setState(() {
        jobListResponse = response;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  void onSelected(Job job) {
    DialogUtil.show(
      dialog: JobDetailsPopup(
        job: job,
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
        totalItems: jobListResponse?.total,
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
        rows: jobListResponse?.jobs?.map(
              (job) {
                DateTime startTime = GawDateUtil.fromApi(job.startTime);

                DateTime endTime = GawDateUtil.fromApi(job.endTime);

                return BaseListItem(
                  items: {
                    TextRowItem(
                      value: job.title,
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
                          onSelected(job);
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
