import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:style_transfer/app/app.dart';

part 'filter_service_isolate.dart';

class FilterBlocImpl extends FilterBloc {
  late final Isolate _isolate;
  late final ReceivePort _receivePort;
  late final SendPort _sendPort;

  static Future<FilterBloc> start({
    required StyleTransferRepository repository,
  }) async {
    final receivePortBloc = ReceivePort();

    final isolate = await Isolate.spawn(
      (input) {
        final (sendPort, rootToken) = input;

        if (rootToken != null) {
          BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);
        }

        final receivePortService = ReceivePort();

        sendPort.send(receivePortService.sendPort);

        final bloc = FilterServiceImpl(
          sendPort: sendPort,
          repository: repository,
        );

        receivePortService
            .where((event) => event is FilterEvent)
            .cast<FilterEvent>()
            .listen(bloc.add);
      },
      (receivePortBloc.sendPort, RootIsolateToken.instance),
    );

    final bloc = FilterBlocImpl()
      .._isolate = isolate
      .._receivePort = receivePortBloc
      ..listen();

    return bloc;
  }

  @override
  void add(FilterEvent event) {
    _sendPort.send(event);
  }

  @override
  Stream<FilterState> get onEmitState => _receivePort
      .map((event) {
        if (event is SendPort) {
          _sendPort = event;
        }

        return event;
      })
      .where((event) => event is FilterState)
      .cast<FilterState>();

  @override
  Future<void> close() {
    _isolate.kill();
    return super.close();
  }
}
