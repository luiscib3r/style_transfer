// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:style_transfer/app/app.dart';

part 'filter_service_worker.dart';

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
