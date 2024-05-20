import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:style_transfer/app/app.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

part 'styler_service_isolate.dart';

class StylerBlocImpl extends StylerBloc {
  late final Isolate _isolate;
  late final ReceivePort _receivePort;
  late final SendPort _sendPort;

  static Future<StylerBloc> start({
    required StyleTransferRepository repository,
  }) async {
    final receivePortBloc = ReceivePort();
    final predict = await Interpreter.fromAsset(
      Assets.models.magentaArbitraryImageStylizationV1256Int8Prediction1,
    );
    final transfer = await Interpreter.fromAsset(
      Assets.models.magentaArbitraryImageStylizationV1256Int8Transfer1,
    );

    final isolate = await Isolate.spawn(
      (input) async {
        final (sendPort, rootToken) = input;

        if (rootToken != null) {
          BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);
        }

        final receivePortService = ReceivePort();

        sendPort.send(receivePortService.sendPort);

        final bloc = StylerServiceImpl(
          sendPort: sendPort,
          repository: repository,
        );

        await bloc.load(
          predictInterpreterAddress: predict.address,
          transferInterpreterAddress: transfer.address,
        );

        receivePortService
            .where((event) => event is StylerEvent)
            .cast<StylerEvent>()
            .listen(bloc.add);
      },
      (receivePortBloc.sendPort, RootIsolateToken.instance),
    );

    final bloc = StylerBlocImpl()
      .._isolate = isolate
      .._receivePort = receivePortBloc
      ..listen();

    return bloc;
  }

  @override
  void add(StylerEvent event) {
    _sendPort.send(event);
  }

  @override
  Stream<StylerState> get onEmitState => _receivePort
      .map((event) {
        if (event is SendPort) {
          _sendPort = event;
        }

        return event;
      })
      .where((event) => event is StylerState)
      .cast<StylerState>();

  @override
  Future<void> close() {
    _isolate.kill();
    return super.close();
  }
}
