import 'dart:typed_data';

import 'package:style_transfer/app/app.dart';

class StyleTransferRepository extends BaseRepository {
  const StyleTransferRepository({
    required ImageDataSource imageDataSource,
  }) : _imageDataSource = imageDataSource;

  final ImageDataSource _imageDataSource;

  Future<Result<Uint8List>> resizeImage({
    required Uint8List image,
    required int size,
  }) =>
      process(
        action: () => _imageDataSource.resizeImage(image: image, size: size),
      );

  Future<Result<Uint8List>> rotateLeft({
    required Uint8List image,
  }) {
    throw UnimplementedError();
  }

  Future<Result<Uint8List>> rotateRight({
    required Uint8List image,
  }) {
    throw UnimplementedError();
  }

  Future<Result<Uint8List>> run({
    required Uint8List image,
    required Uint8List style,
  }) {
    throw UnimplementedError();
  }
}
