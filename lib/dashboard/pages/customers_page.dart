import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_create_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_delete_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_detail_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_history_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

BeamPage customersBeamPage = BeamPage(
  title: LocaleKeys.customers.tr(),
  key: const ValueKey('customers'),
  type: BeamPageType.noTransition,
  child: const CustomersPage(),
);

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  static const String route = '/dashboard/customers';

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage>
    with ScreenStateMixin {
  int itemCount = 25;

  int page = 1;

  CustomerListResponse? customerListResponse;

  List<Customer> selection = [];

  bool allSelected = false;

  String? sortingValue;

  String? term;

  void loadData({
    int? page,
    int? itemCount,
    String? term,
    String? sortTerm,
    bool ascending = true,
  }) {
    setLoading(true);

    setData(() {
      this.term = term;
      this.page = page ?? this.page;
      this.itemCount = itemCount ?? this.itemCount;
    });

    CustomerApi.getCustomers(
      page: page,
      itemCount: itemCount,
      searchTerm: term,
      sortTerm: sortTerm,
      ascending: ascending,
    ).then((response) {
      setData(() {
        customerListResponse = response;
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
      mainRoute: LocaleKeys.customers.tr(),
      subRoute: LocaleKeys.customers.tr(),
      extraActionButtonPadding: 128,
      actionWidget: ActionButton(
        label: 'New customer',
        icon: PixelPerfectIcons.customAdd,
        onTap: () {
          DialogUtil.show(
            dialog: const CustomerCreateDialog(),
            context: context,
          ).then((_) {
            loadData(
              page: 1,
              itemCount: itemCount,
            );
          });
        },
      ),
      child: ScreenSheet(
        topPadding: 156,
        child: GenericListView(
          loading: loading,
          canDelete: selection.isNotEmpty,
          title: LocaleKeys.customers.tr(),
          valueName: LocaleKeys.customers.tr().toLowerCase(),
          onSearch: (String? value) {
            if (value == term) {
              return;
            }
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
              dialog: CustomerDeleteDialog(
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
          totalItems: customerListResponse?.total,
          header: BaseListHeader(
            selected: allSelected,
            onUpdate: (bool? value) {
              setState(() {
                if (value == null) {
                  return;
                }
                if (value) {
                  selection.addAll(customerListResponse?.customers ?? []);
                  allSelected = true;
                } else {
                  selection = [];
                  allSelected = false;
                }
              });
            },
            items: {
              BaseHeaderItem(
                label: LocaleKeys.customerName.tr(),
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
              BaseHeaderItem(
                label: 'Company',
                sorting: sortingValue == 'company_name',
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
                    sortingValue = 'company_name';
                  });
                  loadData(
                    page: 1,
                    itemCount: itemCount,
                    sortTerm: 'company_name',
                    ascending: !ascending,
                  );
                },
              ): ListUtil.sColumn,
              const BaseHeaderItem(
                label: '',
              ): ListUtil.mColumn,
            },
          ),
          rows: customerListResponse?.customers.map(
                (customer) {
                  return BaseListItem(
                    selected: selection.contains(customer),
                    onUpdate: (bool? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        allSelected = false;

                        if (value) {
                          selection.add(customer);
                        } else {
                          selection.remove(customer);
                        }
                      });
                    },
                    onSelected: () {
                      DialogUtil.show(
                        dialog: CustomerDetailDialog(
                          customerId: customer.id!,
                        ),
                        context: context,
                      ).then((_) {
                        loadData();
                      });
                    },
                    items: {
                      ProfileRowItem(
                        firstName: customer.firstName,
                        lastName: customer.lastName,
                        initials: customer.initials,
                        imageUrl: FormattingUtil.formatUrl(
                          customer.profilePictureUrl,
                        ),
                        fixedWidth: ListUtil.mColumn,
                      ): ListUtil.lColumn,
                      SelectableTextRowItem(
                        value: customer.email,
                        fixedWidth: ListUtil.lColumn,
                      ): ListUtil.xLColumn,
                      SelectableTextRowItem(
                        value: customer.phoneNumber,
                        fixedWidth: ListUtil.mColumn,
                      ): ListUtil.lColumn,
                      TextRowItem(
                        value: customer.formatHours(),
                        fixedWidth: ListUtil.xSColumn,
                      ): ListUtil.mColumn,
                      TextRowItem(
                        value: customer.company,
                        fixedWidth: ListUtil.mColumn,
                      ): ListUtil.sColumn,
                      StatusRowItem(
                        value: customer.hasActiveJob == true
                            ? 'Active job'
                            : LocaleKeys.newCopy.tr(),
                        color: customer.hasActiveJob == true
                            ? GawTheme.mainTint
                            : GawTheme.success,
                        visible: customer.hasActiveJob == true
                            ? true
                            : GawDateUtil.tryFromApi(customer.createdAt)
                                    ?.isAfter(
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 3,
                                  ),
                                ) ??
                                false,
                      ): ListUtil.sColumn,
                      IconRowItem(
                        icon: PixelPerfectIcons.timeDiamondpNormal,
                        secondIcon: PixelPerfectIcons.customEye,
                        onTap: () {
                          DialogUtil.show(
                            dialog: CustomerHistoryDialog(
                              customerId: customer.id!,
                            ),
                            context: context,
                          );
                        },
                      ): ListUtil.sColumn,
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
