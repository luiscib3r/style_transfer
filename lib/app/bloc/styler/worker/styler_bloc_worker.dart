// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:style_transfer/app/app.dart';

part 'styler_service_worker.dart';

Uint8List bytesFromJson(String json) => base64.decode(json);
String bytesToJson(Uint8List image) => base64.encode(image);

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
