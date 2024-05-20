part of 'filter_bloc_isolate.dart';

class FilterServiceImpl extends FilterService {
  FilterServiceImpl({
    required SendPort sendPort,
    required super.repository,
  }) : _sendPort = sendPort;

  final SendPort _sendPort;

  @override
  void emitState(FilterState state) {
    _sendPort.send(state);
  }
}
