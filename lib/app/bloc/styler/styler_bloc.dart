// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:style_transfer/app/app.dart';

import 'gallery_saver/gallery_saver.dart'
    if (dart.library.html) 'gallery_saver/gallery_saver_web.dart';

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

  void rotateLeft() => add(const StylerRotateImageLeft());
  void rotateRight() => add(const StylerRotateImageRight());

  void add(StylerEvent event);

  Future<void> saveImage() async {
    if (state is StylerImageProcessed) {
      final image = (state as StylerImageProcessed).image;

      await saveImageToGallery(image);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
