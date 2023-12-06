import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/loading/loading_switcher.dart';
import 'package:flutter_gaw_cms/core/utils/dialog_util.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_create_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_detail_dialog.dart';
import 'package:flutter_package_gaw_api/flutter_package_gaw_api.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

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
  final TextEditingController tecItemsPerPage = TextEditingController(
    text: 12.toString(),
  );

  final TextEditingController tecPages = TextEditingController(
    text: 1.toString(),
  );

  CustomerListResponse? customerListResponse;

  void loadData() {
    setLoading(true);

    CustomerApi.getCustomers().then((response) {
      setLoading(false);
      setState(() {
        customerListResponse = response;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    });
  }

  @override
  void initState() {
    Future(() {
      loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Column(
            children: [
              CmsHeader(),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CustomerCreateDialog(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(PaddingSizes.mainPadding),
                        child: Container(
                          height: 36,
                          width: 120,
                          decoration: BoxDecoration(
                            color: GawTheme.clearBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: MainText(
                              'Add new customer',
                              textStyleOverride: TextStyles.mainStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ScreenSheet(
                  child: LoadingSwitcher(
                    loading: loading,
                    child: GenericListView(
                      title: LocaleKeys.customers.tr(),
                      valueName: LocaleKeys.customers.tr().toLowerCase(),
                      totalItems: customerListResponse?.total,
                      header: ListUtil.makeHeader(
                        {
                          'Name': ListUtil.mColumn,
                          'email': ListUtil.mColumn,
                          'Phone': ListUtil.mColumn,
                          'Company': ListUtil.mColumn,
                          '': ListUtil.lColumn,
                        },
                      ),
                      rows: customerListResponse?.customers.map(
                            (customer) {
                              return InkWell(
                                onTap: () {
                                  DialogUtil.show(
                                      dialog: CustomerDetailDialog(
                                        customerId: customer.id,
                                      ),
                                      context: context);
                                },
                                child: ListUtil.makeRow(
                                  {
                                    TextRowItem(
                                      value: customer.getFullName(),
                                    ): ListUtil.mColumn,
                                    TextRowItem(
                                      value: customer.email,
                                    ): ListUtil.mColumn,
                                    TextRowItem(
                                      value: customer.phoneNumber,
                                    ): ListUtil.mColumn,
                                    TextRowItem(
                                      value: customer.company,
                                    ): ListUtil.mColumn,
                                    const IconRowItem(
                                      icon: PixelPerfectIcons.eyeNormal,
                                    ): ListUtil.lColumn,
                                  },
                                ),
                              );
                            },
                          ).toList() ??
                          [],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
