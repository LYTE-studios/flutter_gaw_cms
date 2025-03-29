import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/application_details_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage dimonasBeamPage = BeamPage(
  title: 'Dimonas',
  key: ValueKey('dimonas'),
  type: BeamPageType.noTransition,
  child: DimonaPage(),
);

class DimonaPage extends StatefulWidget {
  const DimonaPage({super.key});

  static const String route = '/dashboard/dimonas';

  @override
  State<DimonaPage> createState() => _DimonaPageState();
}

class _DimonaPageState extends State<DimonaPage> with ScreenStateMixin {
  int itemCount = 25;
  int page = 1;
  DimonaListResponse? dimonaListResponse;

  // Create a helper method instead of overriding loadData
  void fetchData({
    int? page,
    int? itemCount,
  }) {
    setLoading(true);

    // Update the state with the provided or existing values
    setState(() {
      this.page = page ?? this.page;
      this.itemCount = itemCount ?? this.itemCount;
    });

    // Use the updated state values for the API call
    LegalApi.getDimonas(
      page: this.page,
      itemCount: this.itemCount,
    ).then((response) {
      if (mounted) {
        setState(() {
          dimonaListResponse = response;
        });
      }
    }).catchError((error) {
      if (mounted) {
        ExceptionHandler.show(error);
      }
    }).whenComplete(() {
      if (mounted) {
        setLoading(false);
      }
    });
  }

  // Override the loadData method with the correct signature
  @override
  Future<void> loadData() async {
    fetchData(page: page, itemCount: itemCount);
  }

  @override
  void initState() {
    super.initState();
    // Call loadData directly without passing parameters since
    // they're already initialized as class fields
    Future(() {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Dimonas',
      subRoute: 'Dimonas',
      extraActionButtonPadding: 128,
      child: ScreenSheet(
        topPadding: 156,
        child: GenericListView(
          loading: loading,
          canDelete: false,
          title: 'Dimonas',
          valueName: 'dimonas',
          onEditItemCount: (int index) {
            fetchData(itemCount: index, page: page);
          },
          onChangePage: (int index) {
            fetchData(itemCount: itemCount, page: index);
          },
          page: page,
          itemsPerPage: itemCount,
          totalItems: dimonaListResponse?.total,
          header: BaseListHeader(
            selected: false,
            items: {
              const BaseHeaderItem(
                label: 'Washer',
              ): ListUtil.lColumn,
              const BaseHeaderItem(
                label: 'Status',
              ): ListUtil.sColumn,
              const BaseHeaderItem(
                label: 'ID',
              ): ListUtil.lColumn,
              const BaseHeaderItem(
                label: 'Info',
              ): ListUtil.hugeColumn,
              const BaseHeaderItem(
                label: '',
              ): ListUtil.mColumn,
            },
          ),
          rows: dimonaListResponse?.dimonas.map(
                (dimona) {
                  return BaseListItem(
                    onSelected: () {
                      DialogUtil.show(
                        dialog: ApplicationDetailsDialog(
                          application: dimona.application,
                        ),
                        context: context,
                      );
                    },
                    items: {
                      ProfileRowItem(
                        firstName: dimona.application.worker.firstName,
                        lastName: dimona.application.worker.lastName,
                        imageUrl: dimona.application.worker.profilePictureUrl,
                      ): ListUtil.lColumn,
                      TextRowItem(
                        value: dimona.success == null
                            ? 'Pending'
                            : dimona.success!
                                ? 'Success'
                                : 'Failed',
                        fixedWidth: ListUtil.sColumn,
                      ): ListUtil.sColumn,
                      SelectableTextRowItem(
                        value: dimona.id,
                        fixedWidth: ListUtil.lColumn,
                      ): ListUtil.lColumn,
                      TextRowItem(
                        value: dimona.description,
                        fixedWidth: ListUtil.hugeColumn,
                      ): ListUtil.hugeColumn,
                      IconRowItem(
                        icon: PixelPerfectIcons.customEye,
                        onTap: () {
                          DialogUtil.show(
                            dialog: ApplicationDetailsDialog(
                              application: dimona.application,
                            ),
                            context: context,
                          );
                        },
                      ): ListUtil.mColumn,
                    },
                  );
                },
              ).toList() ??
              [],
        ),
      ),
    );
  }
}