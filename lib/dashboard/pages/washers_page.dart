import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/dialog_util.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_create_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_detail_dialog.dart';
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
  WashersListResponse? washersListResponse;

  void loadData() {
    setLoading(true);

    WashersApi.getWashers().then((response) {
      setLoading(false);
      setState(() {
        washersListResponse = response;
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
              CmsHeader(
                mainRoute: 'Washers',
                subRoute: 'Registered',
              ),
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
                              'Add new washer',
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
                      title: LocaleKeys.washers.tr(),
                      valueName: LocaleKeys.customers.tr().toLowerCase(),
                      totalItems: washersListResponse?.total,
                      header: BaseListHeader(
                        items: {
                          'Name': ListUtil.mColumn,
                          'Email': ListUtil.mColumn,
                          'Phone': ListUtil.mColumn,
                          '': ListUtil.lColumn,
                        },
                      ),
                      rows: washersListResponse?.washers.map(
                            (washer) {
                              return InkWell(
                                onTap: () {
                                  DialogUtil.show(
                                      dialog: CustomerDetailDialog(
                                        customerId: washer.id,
                                      ),
                                      context: context);
                                },
                                child: BaseListItem(
                                  items: {
                                    TextRowItem(value: washer.getFullName()):
                                        ListUtil.mColumn,
                                    TextRowItem(value: washer.email):
                                        ListUtil.mColumn,
                                    TextRowItem(value: washer.phoneNumber):
                                        ListUtil.mColumn,
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
