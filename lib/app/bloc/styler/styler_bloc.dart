// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';
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
  void selectedFilter(Uint8List filter) =>
      add(StylerFilterSelected(filter: filter));

  void add(StylerEvent event);

  Future<void> saveImage() async {
    final image = switch (state) {
      StylerImageProcessed(image: final image) => image,
      StylerImageWithFilter(image: final image) => image,
      _ => null,
    };

    if (image != null) {
      await saveImageToGallery(image);
    }
  }

  Future<void> shareImage() async {
    final image = switch (state) {
      StylerImageProcessed(image: final image) => image,
      StylerImageWithFilter(image: final image) => image,
      _ => null,
    };

    if (image != null) {
      final file = XFile.fromData(image, mimeType: 'image/jpeg');
      await Share.shareXFiles([file]);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
