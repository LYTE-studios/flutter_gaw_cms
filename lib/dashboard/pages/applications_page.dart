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
  @override
  Widget build(BuildContext context) {
    return const BaseLayoutScreen(
      mainRoute: 'Jobs',
      subRoute: 'Applications',
      child: ScreenSheet(
        topPadding: 120,
        child: ApplicationsListView(),
      ),
    );
  }
}

class ApplicationsListView extends StatefulWidget {
  final bool fullView;

  const ApplicationsListView({
    super.key,
    this.fullView = true,
  });

  @override
  State<ApplicationsListView> createState() => _ApplicationsListViewState();
}

class _ApplicationsListViewState extends State<ApplicationsListView>
    with ScreenStateMixin {
  ApplicationListResponse? applicationsListResponse;

  @override
  void initState() {
    Future(loadData);
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return GenericListView(
      loading: loading,
      title: LocaleKeys.applications.tr(),
      valueName: LocaleKeys.applications.tr().toLowerCase(),
      totalItems: 0,
      showFooter: widget.fullView,
      showHeader: widget.fullView,
      header: const BaseListHeader(
        items: {
          'Washer name': ListUtil.xLColumn,
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
                    ProfileRowItem(
                      firstName: application.washer.firstName,
                      lastName: application.washer.lastName,
                      imageUrl: application.washer.profilePictureUrl,
                    ): ListUtil.xLColumn,
                    TextRowItem(
                      value: GawDateUtil.tryFormatReadableDate(
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
    );
  }
}
