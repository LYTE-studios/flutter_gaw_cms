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

  void loadData({int? page, int? itemCount}) {
    setLoading(true);

    setState(() {
      page = page;
      itemCount = itemCount;
    });

    CustomerApi.getCustomers(page: page, itemCount: itemCount).then((response) {
      setState(() {
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
          onEditItemCount: (int index) {
            loadData(itemCount: index, page: page);
          },
          onChangePage: (int index) {
            loadData(itemCount: itemCount, page: index);
          },
          page: page,
          itemsPerPage: itemCount,
          totalItems: customerListResponse?.total,
          header: const BaseListHeader(
            items: {
              'Name': ListUtil.lColumn,
              'Email': ListUtil.xLColumn,
              'Phone': ListUtil.mColumn,
              'Company': ListUtil.mColumn,
              '': ListUtil.xSColumn,
            },
          ),
          rows: customerListResponse?.customers.map(
                (customer) {
                  return InkWell(
                    onTap: () {
                      DialogUtil.show(
                        dialog: CustomerDetailDialog(
                          customerId: customer.id!,
                        ),
                        context: context,
                      );
                    },
                    child: BaseListItem(
                      items: {
                        TextRowItem(
                          value: customer.getFullName(),
                        ): ListUtil.lColumn,
                        SelectableTextRowItem(
                          value: customer.email,
                        ): ListUtil.xLColumn,
                        SelectableTextRowItem(
                          value: customer.phoneNumber,
                        ): ListUtil.mColumn,
                        TextRowItem(
                          value: customer.company,
                        ): ListUtil.mColumn,
                        const IconRowItem(
                          icon: PixelPerfectIcons.eyeNormal,
                        ): ListUtil.xSColumn,
                      },
                    ),
                  );
                },
              ).toList() ??
              [],
        ),
      ),
    );
  }
}
