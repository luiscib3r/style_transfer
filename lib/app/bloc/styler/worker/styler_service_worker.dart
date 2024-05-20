part of 'styler_bloc_worker.dart';

class StylerServiceImpl extends StylerService {
  StylerServiceImpl({required super.repository}) {
    DedicatedWorkerGlobalScope.instance.onMessage.listen((message) {
      final data = message.data as String;
      final event = StylerEvent.decode(data);
      add(event);
    });
  }

  @override
  void emitState(StylerState state) {
    DedicatedWorkerGlobalScope.instance.postMessage(state.encode);
  }
}
