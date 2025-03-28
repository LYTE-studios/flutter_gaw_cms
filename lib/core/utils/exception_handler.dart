import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter_gaw_cms/core/screens/base_dialog_screen.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/src/utility/dialog_util.dart';

class ExceptionHandler {
  static Future<void> show(
    Object exception, {
    String? message,
    BuildContext? context,
    StackTrace? stackTrace,
  }) async {
    developer.log(exception.toString());

    String? title;

    if (exception is GawException) {
      title = exception.title;
      message = exception.message;
    }

    bool emptyContext = (globalScaffoldKey.currentContext ?? context) == null;

    if (emptyContext) {
      return;
    }

    await DialogUtil.show(
      dialog: BaseDialogScreen(
        exception: exception,
        stackTrace: stackTrace,
        title: title,
        description: message,
      ),
      context: globalScaffoldKey.currentContext ?? context!,
    );
  }
}
