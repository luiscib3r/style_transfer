import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:style_transfer/app/app.dart';

part 'styler_event.dart';
part 'styler_service.dart';
part 'styler_state.dart';

abstract class StylerBloc extends Cubit<StylerState> {
  StylerBloc() : super(const StylerInitial());

  void listen() {
    _subscription = onEmitState.listen(emit);
  }

  late final StreamSubscription<StylerState> _subscription;

  Stream<StylerState> get onEmitState;

  void selectImage(Uint8List image) => add(StylerImageSelected(image: image));

  void add(StylerEvent event);

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
