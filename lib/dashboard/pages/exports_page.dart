import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

BeamPage exportsBeamPage = const BeamPage(
  title: 'Exports',
  key: ValueKey('exports'),
  type: BeamPageType.noTransition,
  child: ExportsPage(),
);

class ExportsPage extends ConsumerStatefulWidget {
  const ExportsPage({super.key});

  static const String route = '/dashboard/exports';

  @override
  ConsumerState<ExportsPage> createState() => _ExportsPageState();
}

class _ExportsPageState extends ConsumerState<ExportsPage>
    with ScreenStateMixin {
  int itemCount = 25;

  int page = 1;

  ExportsListResponse? exportsListResponse;

  String? sortingValue;

  void loadData({
    int? page,
    int? itemCount,
    String? term,
    String? sortTerm,
    bool ascending = true,
  }) {
    setLoading(true);

    setData(() {
      this.page = page ?? this.page;
      this.itemCount = itemCount ?? this.itemCount;
    });

    ExportsApi.getExports(
      page: page,
      itemCount: itemCount,
      sortTerm: sortTerm,
      ascending: ascending,
    ).then((response) {
      setData(() {
        exportsListResponse = response;
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

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Exports',
      subRoute: 'Exports',
      extraActionButtonPadding: 128,
      child: ScreenSheet(
        topPadding: 156,
        child: GenericListView(
          loading: loading,
          canDelete: false,
          title: 'Exports',
          valueName: 'exports',
          onEditItemCount: (int index) {
            loadData(itemCount: index, page: page);
          },
          onChangePage: (int index) {
            loadData(itemCount: itemCount, page: index);
          },
          page: page,
          itemsPerPage: itemCount,
          totalItems: exportsListResponse?.total,
          header: BaseListHeader(
            items: {
              BaseHeaderItem(
                label: LocaleKeys.name.tr(),
                sorting: sortingValue == 'name',
                onSort: (bool? ascending) {
                  if (ascending == null) {
                    setState(() {
                      sortingValue = null;
                    });
                    loadData(
                      page: 1,
                      itemCount: itemCount,
                    );
                    return;
                  }
                  setState(() {
                    sortingValue = 'name';
                  });
                  loadData(
                    page: 1,
                    itemCount: itemCount,
                    sortTerm: sortingValue,
                    ascending: !ascending,
                  );
                },
              ): ListUtil.hugeColumn,
              BaseHeaderItem(
                label: 'Created at',
                sorting: sortingValue == 'created',
                onSort: (bool? ascending) {
                  if (ascending == null) {
                    setState(() {
                      sortingValue = null;
                    });
                    loadData(
                      page: 1,
                      itemCount: itemCount,
                    );
                    return;
                  }
                  setState(() {
                    sortingValue = 'created';
                  });
                  loadData(
                    page: 1,
                    itemCount: itemCount,
                    sortTerm: sortingValue,
                    ascending: !ascending,
                  );
                },
              ): ListUtil.xLColumn,
              const BaseHeaderItem(
                label: '',
              ): ListUtil.sColumn,
              const BaseHeaderItem(
                label: '  ',
              ): ListUtil.miniColumn,
            },
          ),
          rows: exportsListResponse?.exports?.map(
                (export) {
                  return BaseListItem(
                    onSelected: () {
                      DownloadUtil.downloadFile(
                        export.fileUrl,
                        export.fileName,
                      );
                    },
                    items: {
                      const SizedBox(): 6,
                      TextRowItem(
                        value: export.name,
                        fixedWidth: ListUtil.hugeColumn,
                      ): ListUtil.hugeColumn,
                      SelectableTextRowItem(
                        value: GawDateUtil.formatFullDate(
                          GawDateUtil.fromApi(export.createdAt),
                        ),
                        fixedWidth: ListUtil.lColumn,
                      ): ListUtil.xLColumn,
                      const IconRowItem(
                        icon: PixelPerfectIcons.download,
                      ): ListUtil.miniColumn,
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
