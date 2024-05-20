// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:style_transfer/app/app.dart';

part 'filter_service_worker.dart';

Uint8List bytesFromJson(String json) => base64.decode(json);
String bytesToJson(Uint8List image) => base64.encode(image);

class FilterBlocImpl extends FilterBloc {
  FilterBlocImpl();

  late final Worker worker;

  static Future<FilterBlocImpl> start({
    required StyleTransferRepository repository,
  }) async {
    final bloc = FilterBlocImpl()
      ..worker = Worker('filter_worker.dart.js')
      ..listen();

    return bloc;
  }

  @override
  void add(FilterEvent event) {
    worker.postMessage(event.encode);
  }

  @override
  Stream<FilterState> get onEmitState => worker.onMessage.map((message) {
        final data = message.data as String;

        return FilterState.decode(data);
      });
}
