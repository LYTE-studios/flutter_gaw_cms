import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_delete_dialog.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_details_dialog.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_history_dialog.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washers_create_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage washersBeamPage = BeamPage(
  title: 'Workers',
  key: ValueKey('workers'),
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

  WorkersListResponse? washersListResponse;

  List<Worker> selection = [];

  bool allSelected = false;

  String? sortingValue;

  String? term;

  @override
  Future<void> loadData() async {
    WorkersListResponse? response = await WorkersApi.getWorkers(
      page: page,
      itemCount: itemCount,
      searchTerm: term,
    );

    setState(() {
      washersListResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Workers',
      subRoute: 'Workers',
      extraActionButtonPadding: 128,
      actionWidget: ActionButton(
        label: 'New Worker',
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
            if (value == term) {
              return;
            }

            setState(() {
              term = value;
            });

            setData();
          },
          onEditItemCount: (int index) {
            if (index == itemCount) {
              return;
            }
            setState(() {
              itemCount = index;
            });
            setData();
          },
          onChangePage: (int index) {
            if (index == page) {
              return;
            }
            setData();
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

              setData();
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
                  selection.addAll(washersListResponse?.workers ?? []);
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
              ): ListUtil.mColumn,
              const BaseHeaderItem(
                label: '',
              ): ListUtil.sColumn,
              const BaseHeaderItem(
                label: '  ',
              ): ListUtil.mColumn,
            },
          ),
          rows: washersListResponse?.workers.map(
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
                      );
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
                      const TextRowItem(
                        value: null,
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
                      IconRowItem(
                        icon: PixelPerfectIcons.timeDiamondpNormal,
                        secondIcon: PixelPerfectIcons.customEye,
                        onTap: () {
                          DialogUtil.show(
                            dialog: WasherHistoryDialog(washerId: washer.id!),
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
