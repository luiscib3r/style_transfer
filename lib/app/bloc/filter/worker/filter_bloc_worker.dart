import 'package:style_transfer/app/app.dart';

part 'filter_service_worker.dart';

class FilterBlocImpl extends FilterBloc {
  FilterBlocImpl();

  static Future<FilterBlocImpl> start({
    required StyleTransferRepository repository,
  }) async {
    throw UnimplementedError();
  }

  @override
  void add(FilterEvent event) {
    throw UnimplementedError();
  }

  @override
  Stream<FilterState> get onEmitState => throw UnimplementedError();
}
