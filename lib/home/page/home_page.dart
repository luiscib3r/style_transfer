import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/editor/editor.dart';
import 'package:style_transfer/home/home.dart';

class HomePage extends GoRoute {
  HomePage()
      : super(
          path: _path,
          name: _name,
          pageBuilder: (context, state) => const MaterialPage(
            name: _name,
            child: HomeView(),
          ),
          routes: [
            EditorPage(),
          ],
        );

  static const _path = '/';
  static const _name = 'Home';
  static String get route => _path;
  static void open(BuildContext context) => context.go(route);
}
