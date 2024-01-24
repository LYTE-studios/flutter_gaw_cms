import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage applicationsBeamPage = BeamPage(
  title: 'Applications',
  key: ValueKey('applications'),
  type: BeamPageType.noTransition,
  child: ApplicationsPage(),
);

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  static const String route = '/dashboard/washers/applications';

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage>
    with ScreenStateMixin {
  ApplicationListResponse? applicationsListResponse;

  void loadData() {
    setLoading(true);

    JobsApi.getApplications().then((response) {
      setState(() {
        applicationsListResponse = response;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  @override
  void initState() {
    Future(loadData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Jobs',
      subRoute: 'Applications',
      child: ScreenSheet(
        topPadding: 180,
        child: GenericListView(
          loading: loading,
          title: LocaleKeys.applications.tr(),
          valueName: LocaleKeys.applications.tr().toLowerCase(),
          totalItems: 0,
          header: BaseListHeader(
            items: {
              'Washer name': ListUtil.mColumn,
              'Date': ListUtil.sColumn,
              'Region': ListUtil.mColumn,
              'Distance': ListUtil.sColumn,
              '': ListUtil.sColumn,
            },
          ),
          rows: applicationsListResponse?.applications.map(
                (application) {
                  return InkWell(
                    onTap: () {},
                    child: BaseListItem(
                      items: {
                        TextRowItem(
                          value: application.washer.getFullName(),
                        ): ListUtil.mColumn,
                        SelectableTextRowItem(
                          value: GawDateUtil.formatDate(
                            GawDateUtil.tryFromApi(application.createdAt),
                          ),
                        ): ListUtil.sColumn,
                        SelectableTextRowItem(
                          value: application.address.city ??
                              application.address.postalCode,
                        ): ListUtil.mColumn,
                        TextRowItem(
                          value: GeoUtil.formatDistance(application.distance),
                        ): ListUtil.sColumn,
                        ActionButtonRowItem(
                          label: 'View application',
                          onTap: () {},
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
