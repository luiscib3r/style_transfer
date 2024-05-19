import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:style_transfer/app/app.dart';

class ImageDataSource {
  const ImageDataSource();

  Future<Uint8List> resizeImage({
    required Uint8List image,
    required int size,
  }) async {
    final cmd = Command()
      ..decodeImage(image)
      ..copyResize(width: size, height: size)
      ..encodeJpg();

    final output = await cmd.executeThread();

    if (output.outputBytes != null) {
      return output.outputBytes!;
    } else {
      throw const ImageResizeException();
    }
  }
}
