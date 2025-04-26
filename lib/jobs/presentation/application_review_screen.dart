import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/dashboard_router.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/dashboard/pages/applications_page.dart';
import 'package:gaw_ui/gaw_ui.dart';

class ApplicationReviewScreen extends StatefulWidget {
  final String jobId;

  const ApplicationReviewScreen({
    super.key,
    required this.jobId,
  });

  static const String kJobId = 'jobId';

  static const String route = '/dashboard/washers/applications/:$kJobId';

  static const double bannerHeight = 210;

  @override
  State<ApplicationReviewScreen> createState() =>
      _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends State<ApplicationReviewScreen>
    with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Workers',
      subRoute: 'Applications',
      goBack: () {
        dashboardRouter.beamBack();
      },
      extraActionButtonPadding: 42,
      bannerHeightOverride: ApplicationReviewScreen.bannerHeight,
      child: ScreenSheet(
        topPadding: 180,
        child: ApplicationsListView(
          jobId: widget.jobId,
          fullView: false,
        ),
      ),
    );
  }
}
