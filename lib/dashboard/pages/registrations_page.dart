import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_details_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage registrationsBeamPage = BeamPage(
  title: 'Registrations',
  key: ValueKey('registrations'),
  type: BeamPageType.noTransition,
  child: RegistrationsPage(),
);

class RegistrationsPage extends ConsumerStatefulWidget {
  const RegistrationsPage({super.key});

  static const String route = '/dashboard/washers/registrations';

  @override
  ConsumerState<RegistrationsPage> createState() => _RegistrationsPageState();
}

class _RegistrationsPageState extends ConsumerState<RegistrationsPage>
    with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return const BaseLayoutScreen(
      mainRoute: 'Washers',
      subRoute: 'Registrations',
      child: ScreenSheet(
        topPadding: 120,
        child: RegistrationsListView(),
      ),
    );
  }
}

class RegistrationsListView extends StatefulWidget {
  const RegistrationsListView({
    super.key,
  });

  @override
  State<RegistrationsListView> createState() => _RegistrationsListViewState();
}

class _RegistrationsListViewState extends State<RegistrationsListView>
    with ScreenStateMixin {
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

    page ??= this.page;
    itemCount ??= this.itemCount;

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
      showRegistered: true,
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

  void onSelected(Washer washer) {
    DialogUtil.show(
      dialog: WasherDetailsDialog(
        washerId: washer.id,
      ),
      context: context,
    ).then((_) => loadData(
          itemCount: itemCount,
          page: page,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GenericListView(
      loading: loading,
      title: 'Registrations',
      valueName: 'registrations',
      itemsPerPage: washersListResponse?.itemsPerPage,
      totalItems: washersListResponse?.total ?? 0,
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
      header: BaseListHeader(
        items: {
          const BaseHeaderItem(
            label: 'Washer name',
          ): ListUtil.xLColumn,
          const BaseHeaderItem(
            label: 'Email',
          ): ListUtil.xLColumn,
          const BaseHeaderItem(
            label: 'Date',
          ): ListUtil.mColumn,
        },
      ),
      rows: washersListResponse?.washers.map(
            (washer) {
              return BaseListItem(
                items: {
                  ProfileRowItem(
                    firstName: washer.firstName,
                    lastName: washer.lastName,
                    imageUrl: FormattingUtil.formatUrl(
                      washer.profilePictureUrl,
                    ),
                  ): ListUtil.xLColumn,
                  SelectableTextRowItem(
                    value: washer.email,
                  ): ListUtil.xLColumn,
                  TextRowItem(
                    value: GawDateUtil.tryFormatReadableDate(
                      GawDateUtil.tryFromApi(washer.createdAt),
                    ),
                  ): ListUtil.mColumn,
                  BaseRowItem(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 128,
                          child: _ApprovalButton(
                            label: 'Approve',
                            icon: PixelPerfectIcons.checkMedium,
                            backgroundColor: GawTheme.mainTint,
                            textColor: GawTheme.clearText,
                            onTap: () {
                              setLoading(true);

                              WashersApi.acceptWasher(
                                id: washer.id!,
                              )
                                  .then((_) => loadData(
                                      itemCount: itemCount, page: page))
                                  .whenComplete(() => setLoading(false));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 105,
                          child: _ApprovalButton(
                            label: 'Deny',
                            icon: PixelPerfectIcons.xMedium,
                            backgroundColor: GawTheme.clearText,
                            textColor: GawTheme.mainTint,
                            onTap: () {
                              setLoading(true);

                              WashersApi.deleteWasher(
                                id: washer.id!,
                              )
                                  .then((_) => loadData(
                                      itemCount: itemCount, page: page))
                                  .whenComplete(() => setLoading(false));
                            },
                          ),
                        ),
                        ColorlessInkWell(
                          onTap: () {
                            onSelected(washer);
                          },
                          child: const SizedBox(
                            width: 56,
                            child: IconRowItem(
                              icon: PixelPerfectIcons.customEye,
                            ),
                          ),
                        )
                      ],
                    ),
                  ): 320,
                },
              );
            },
          ).toList() ??
          [],
    );
  }
}

class _ApprovalButton extends StatelessWidget {
  final String label;

  final String icon;

  final bool outline;

  final Color backgroundColor;

  final Color textColor;

  final Function()? onTap;

  const _ApprovalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.outline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingSizes.mainPadding,
      ),
      child: ColorlessInkWell(
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: outline
                ? null
                : const Border.fromBorderSide(
                    Borders.thickMainTintSide,
                  ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: PaddingSizes.mainPadding,
                ),
                child: MainText(
                  label,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: PaddingSizes.smallPadding,
                ),
                child: SizedBox(
                  height: 21,
                  width: 21,
                  child: SvgIcon(
                    icon,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
