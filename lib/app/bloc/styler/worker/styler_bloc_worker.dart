import 'package:style_transfer/app/app.dart';

part 'styler_service_worker.dart';

class StylerBlocImpl extends StylerBloc {
  StylerBlocImpl();

  static Future<StylerBlocImpl> start({
    required StyleTransferRepository repository,
  }) async {
    throw UnimplementedError();
  }

  @override
  void add(StylerEvent event) {
    throw UnimplementedError();
  }

  @override
  Stream<StylerState> get onEmitState => throw UnimplementedError();
}
