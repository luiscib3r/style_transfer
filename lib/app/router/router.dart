import 'package:flutter/foundation.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/home/home.dart';

final appRouter = GoRouter(
  initialLocation: HomePage.route,
  routes: [
    HomePage(),
  ],
  debugLogDiagnostics: kDebugMode,
);
