// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:style_transfer/app/app.dart';

part 'styler_service_worker.dart';

class StylerBlocImpl extends StylerBloc {
  late final Worker worker;

  static Future<StylerBlocImpl> start({
    required StyleTransferRepository repository,
  }) async {
    final bloc = StylerBlocImpl()
      ..worker = Worker('styler_worker.dart.js')
      ..listen();

    return bloc;
  }

  @override
  void add(StylerEvent event) {
    worker.postMessage(event.encode);
  }

  @override
  Stream<StylerState> get onEmitState => worker.onMessage.map((message) {
        final data = message.data as String;

        return StylerState.decode(data);
      });
}
