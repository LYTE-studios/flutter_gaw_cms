import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_create_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_detail_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage customersBeamPage = BeamPage(
  title: 'Customers',
  key: ValueKey('customers'),
  type: BeamPageType.noTransition,
  child: CustomersPage(),
);

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  static const String route = '/dashboard/customers';

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> with ScreenStateMixin {
  int itemCount = 25;

  int page = 1;

  CustomerListResponse? customerListResponse;

  List<Customer> selection = [];

  bool allSelected = false;

  void loadData({int? page, int? itemCount, String? term}) {
    setLoading(true);

    setData(() {
      page = page;
      itemCount = itemCount;
    });

    CustomerApi.getCustomers(
      page: page,
      itemCount: itemCount,
      searchTerm: term,
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
      extraActionButtonPadding: 156,
      actionWidget: ActionButton(
        label: 'Create new customer',
        icon: PixelPerfectIcons.customAdd,
        onTap: () {
          DialogUtil.show(
            dialog: const CustomerCreateDialog(),
            context: context,
          ).then((_) {
            loadData();
          });
        },
      ),
      child: ScreenSheet(
        topPadding: 120,
        child: GenericListView(
          loading: loading,
          title: LocaleKeys.customers.tr(),
          valueName: LocaleKeys.customers.tr().toLowerCase(),
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
          itemsPerPage: itemCount,
          totalItems: customerListResponse?.total,
          header: BaseListHeader(
            selected: allSelected,
            onUpdate: (bool? value) {
              if (value == null) {
                return;
              }
              setState(() {
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
              'Customer name': ListUtil.lColumn,
              'Email': ListUtil.xLColumn,
              'Phone': ListUtil.lColumn,
              'Hours': ListUtil.mColumn,
              '': ListUtil.sColumn,
              'Company': ListUtil.mColumn,
              ' ': ListUtil.xSColumn,
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
                      );
                    },
                    items: {
                      ProfileRowItem(
                        firstName: customer.firstName,
                        lastName: customer.lastName,
                        initials: customer.initials,
                        imageUrl: customer.profilePictureUrl,
                      ): ListUtil.lColumn,
                      SelectableTextRowItem(
                        value: customer.email,
                      ): ListUtil.xLColumn,
                      SelectableTextRowItem(
                        value: customer.phoneNumber,
                      ): ListUtil.lColumn,
                      const TextRowItem(
                        value: '',
                      ): ListUtil.mColumn,
                      StatusRowItem(
                        value: 'New',
                        color: GawTheme.success,
                        visible:
                            GawDateUtil.tryFromApi(customer.createdAt)?.isAfter(
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 3,
                                  ),
                                ) ??
                                false,
                      ): ListUtil.sColumn,
                      TextRowItem(
                        value: customer.company,
                      ): ListUtil.mColumn,
                      const IconRowItem(
                        icon: PixelPerfectIcons.eyeNormal,
                      ): ListUtil.xSColumn,
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
