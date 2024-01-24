import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
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
    return BaseLayoutScreen(
      mainRoute: 'Washers',
      subRoute: 'Washers',
      extraActionButtonPadding: 156,
      actionWidget: ActionButton(
        label: 'Create new washer',
        onTap: () {
          // TODO
        },
      ),
      child: ScreenSheet(
        topPadding: 120,
        child: GenericListView(
          loading: loading,
          title: LocaleKeys.washers.tr(),
          valueName: LocaleKeys.customers.tr().toLowerCase(),
          totalItems: washersListResponse?.total,
          header: const BaseListHeader(
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
                        TextRowItem(value: washer.email): ListUtil.mColumn,
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
    );
  }
}
