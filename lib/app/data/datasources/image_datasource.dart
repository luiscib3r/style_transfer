import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:style_transfer/app/app.dart';

class ImageDataSource {
  const ImageDataSource();

  Future<Uint8List> resizeImage({
    required Uint8List image,
    required int size,
  }) async {
    var img = decodeImage(image);

    if (img == null) {
      throw const ImageDecodeException();
    }

    final max = img.width > img.height ? img.width : img.height;

    img = copyExpandCanvas(img, newHeight: max, newWidth: max);

    img = copyResizeCropSquare(
      img,
      size: size,
      interpolation: Interpolation.cubic,
    );

    final output = encodeJpg(img);

    return output;
  }

  Future<Uint8List> rotateLeft({
    required Uint8List image,
  }) async {
    var img = decodeImage(image);

    if (img == null) {
      throw const ImageDecodeException();
    }

    img = copyRotate(img, angle: -90);

    final output = encodeJpg(img);

    return output;
  }

  Future<Uint8List> rotateRight({
    required Uint8List image,
  }) async {
    var img = decodeImage(image);

    if (img == null) {
      throw const ImageDecodeException();
    }

    img = copyRotate(img, angle: 90);

    final output = encodeJpg(img);

    return output;
  }
}
