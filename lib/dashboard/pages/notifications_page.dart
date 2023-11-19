import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage notificationsBeamPage = BeamPage(
  title: 'Notifications',
  key: ValueKey('notifications'),
  type: BeamPageType.noTransition,
  child: NotificationsPage(),
);

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static const String route = '/notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GawTheme.background,
      body: Column(
        children: [],
      ),
    );
  }
}
