import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/app/webpath/webpath.dart'
    if (dart.library.html) 'package:style_transfer/app/webpath/webpath_web.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      log(error.toString(), stackTrace: stack);
      return true;
    };
  }

  setWebPath();

  runApp(await builder());
}
