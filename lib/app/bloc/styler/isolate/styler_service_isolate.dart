part of 'styler_bloc_isolate.dart';

class StylerServiceImpl extends StylerService {
  StylerServiceImpl({
    required SendPort sendPort,
    required super.repository,
  }) : _sendPort = sendPort;

  final SendPort _sendPort;

  @override
  void emitState(StylerState state) {
    _sendPort.send(state);
  }
}
