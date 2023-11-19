import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage washersBeamPage = BeamPage(
  title: 'Washers',
  key: ValueKey('washers'),
  type: BeamPageType.noTransition,
  child: WashersPage(),
);

class WashersPage extends StatefulWidget {
  const WashersPage({super.key});

  static const String route = '/washers';

  @override
  State<WashersPage> createState() => _WashersPageState();
}

class _WashersPageState extends State<WashersPage> {
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
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 2,
                child: ScreenSheet(
                  child: GenericListView(
                    title: LocaleKeys.washers.tr(),
                    valueName: LocaleKeys.washers.tr().toLowerCase(),
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
