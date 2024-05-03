import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_delete_dialog.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_details_dialog.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washers_create_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage washersBeamPage = BeamPage(
  title: 'Washers',
  key: ValueKey('washers'),
  type: BeamPageType.noTransition,
  child: WashersPage(),
);

class WashersPage extends StatefulWidget {
  const WashersPage({super.key});

  static const String route = '/dashboard/washers';

  @override
  State<WashersPage> createState() => _WashersPageState();
}

class _WashersPageState extends State<WashersPage> with ScreenStateMixin {
  int itemCount = 25;

  int page = 1;

  WashersListResponse? washersListResponse;

  List<Washer> selection = [];

  bool allSelected = false;

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

    WashersApi.getWashers(
      page: page,
      itemCount: itemCount,
      searchTerm: term,
      sortTerm: sortTerm,
      ascending: ascending,
    ).then((response) {
      setData(() {
        washersListResponse = response;
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
      mainRoute: 'Washers',
      subRoute: 'Washers',
      extraActionButtonPadding: 128,
      actionWidget: ActionButton(
        label: 'New washer',
        icon: PixelPerfectIcons.customAdd,
        onTap: () {
          DialogUtil.show(
            dialog: const WasherCreateDialog(),
            context: context,
          );
        },
      ),
      child: ScreenSheet(
        topPadding: 156,
        child: GenericListView(
          loading: loading,
          canDelete: selection.isNotEmpty,
          title: LocaleKeys.washers.tr(),
          valueName: LocaleKeys.washers.tr().toLowerCase(),
          onSearch: (String? value) {
            loadData(page: 1, itemCount: itemCount, term: value);
          },
          onEditItemCount: (int index) {
            loadData(itemCount: index, page: page);
          },
          onChangePage: (int index) {
            loadData(itemCount: itemCount, page: index);
          },
          page: page,
          onDelete: () {
            if (selection.isEmpty) {
              return;
            }
            DialogUtil.show(
              dialog: WasherDeleteDialog(
                ids: selection.map((e) => e.id ?? '').toList(),
              ),
              context: context,
            ).then((_) {
              selection = [];

              loadData(
                page: 1,
                itemCount: itemCount,
              );
            });
          },
          itemsPerPage: itemCount,
          totalItems: washersListResponse?.total,
          header: BaseListHeader(
            selected: allSelected,
            onUpdate: (bool? value) {
              setState(() {
                if (value == null) {
                  return;
                }
                if (value) {
                  selection.addAll(washersListResponse?.washers ?? []);
                  allSelected = true;
                } else {
                  selection = [];
                  allSelected = false;
                }
              });
            },
            items: {
              BaseHeaderItem(
                label: LocaleKeys.name.tr(),
                sorting: sortingValue == 'first_name',
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
                    sortingValue = 'first_name';
                  });
                  loadData(
                    page: 1,
                    itemCount: itemCount,
                    sortTerm: 'first_name',
                    ascending: !ascending,
                  );
                },
              ): ListUtil.lColumn,
              BaseHeaderItem(
                label: LocaleKeys.email.tr(),
              ): ListUtil.xLColumn,
              BaseHeaderItem(
                label: LocaleKeys.phone.tr(),
              ): ListUtil.lColumn,
              BaseHeaderItem(
                label: LocaleKeys.hours.tr(),
                sorting: sortingValue == 'hours',
                onSort: (bool? ascending) {
                  if (ascending == null) {
                    setState(() {
                      sortingValue = null;
                    });
                    return;
                  }
                  setState(() {
                    sortingValue = 'hours';
                  });
                  loadData(
                    page: 1,
                    itemCount: itemCount,
                    sortTerm: 'hours',
                    ascending: ascending,
                  );
                },
              ): ListUtil.mColumn,
              const BaseHeaderItem(
                label: '',
              ): ListUtil.sColumn,
              const BaseHeaderItem(
                label: '  ',
              ): ListUtil.miniColumn,
            },
          ),
          rows: washersListResponse?.washers.map(
                (washer) {
                  return BaseListItem(
                    selected: selection.contains(washer),
                    onUpdate: (bool? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        allSelected = false;

                        if (value) {
                          selection.add(washer);
                        } else {
                          selection.remove(washer);
                        }
                      });
                    },
                    onSelected: () {
                      DialogUtil.show(
                        dialog: WasherDetailsDialog(
                          washerId: washer.id!,
                        ),
                        context: context,
                      ).then((_) {
                        loadData();
                      });
                    },
                    items: {
                      ProfileRowItem(
                        firstName: washer.firstName,
                        lastName: washer.lastName,
                        initials: washer.initials,
                        imageUrl: FormattingUtil.formatUrl(
                          washer.profilePictureUrl,
                        ),
                        fixedWidth: ListUtil.mColumn,
                      ): ListUtil.lColumn,
                      SelectableTextRowItem(
                        value: washer.email,
                        fixedWidth: ListUtil.lColumn,
                      ): ListUtil.xLColumn,
                      SelectableTextRowItem(
                        value: washer.phoneNumber,
                        fixedWidth: ListUtil.mColumn,
                      ): ListUtil.lColumn,
                      TextRowItem(
                        value: washer.formatHours(),
                        fixedWidth: ListUtil.xSColumn,
                      ): ListUtil.mColumn,
                      StatusRowItem(
                        value: LocaleKeys.newCopy.tr(),
                        color: GawTheme.success,
                        visible:
                            GawDateUtil.tryFromApi(washer.createdAt)?.isAfter(
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 3,
                                  ),
                                ) ??
                                false,
                      ): ListUtil.xSColumn,
                      const IconRowItem(
                        icon: PixelPerfectIcons.customEye,
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
