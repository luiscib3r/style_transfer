import 'package:flutter/cupertino.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/editor/editor.dart';

class EditorPage extends GoRoute {
  EditorPage()
      : super(
          path: _path,
          name: _name,
          pageBuilder: (context, state) {
            context.read<FilterBloc>().loadFilters();

            return const CupertinoPage(
              name: _name,
              child: EditorView(),
            );
          },
        );

  static const _path = 'editor';
  static const _name = 'Editor';
  static String get route => '/$_path';
  static void open(BuildContext context) => context.go(route);
}
