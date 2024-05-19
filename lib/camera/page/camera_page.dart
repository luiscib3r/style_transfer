import 'package:flutter/cupertino.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/camera/camera.dart';

class CameraPage extends GoRoute {
  CameraPage()
      : super(
          path: _path,
          name: _name,
          pageBuilder: (context, state) => const CupertinoPage(
            name: _name,
            child: CameraView(),
          ),
        );

  static const _path = 'camera';
  static const _name = 'Camera';
  static String get route => '/$_path';
  static void open(BuildContext context) => context.go(route);
}
