part of 'filter_bloc_worker.dart';

class FilterServiceImpl extends FilterService {
  FilterServiceImpl({required super.repository}) {
    DedicatedWorkerGlobalScope.instance.onMessage.listen((message) {
      final data = message.data as String;
      final event = FilterEvent.decode(data);
      add(event);
    });
  }

  @override
  void emitState(FilterState state) {
    DedicatedWorkerGlobalScope.instance.postMessage(state.encode);
  }
}
