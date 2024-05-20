import 'dart:typed_data';

import 'package:style_transfer/app/app.dart';

class StyleTransferRepository extends BaseRepository {
  const StyleTransferRepository({
    required ImageDataSource imageDataSource,
    required StylerDataSource stylerDataSource,
  })  : _imageDataSource = imageDataSource,
        _stylerDataSource = stylerDataSource;

  final ImageDataSource _imageDataSource;
  final StylerDataSource _stylerDataSource;

  Future<void> load({
    int? predictInterpreterAddress,
    int? transferInterpreterAddress,
    String? baseUrl,
  }) =>
      _stylerDataSource.load(
        predictInterpreterAddress: predictInterpreterAddress,
        transferInterpreterAddress: transferInterpreterAddress,
        baseUrl: baseUrl,
      );

  Future<Result<Uint8List>> resizeImage({
    required Uint8List image,
    required int size,
  }) =>
      process(
        action: () => _imageDataSource.resizeImage(image: image, size: size),
      );

  Future<Result<Uint8List>> rotateLeft({
    required Uint8List image,
  }) =>
      process(
        action: () => _imageDataSource.rotateLeft(image: image),
      );

  Future<Result<Uint8List>> rotateRight({
    required Uint8List image,
  }) =>
      process(
        action: () => _imageDataSource.rotateRight(image: image),
      );

  Future<Result<Uint8List>> run({
    required Uint8List image,
    required Uint8List style,
  }) =>
      process(
        action: () => _stylerDataSource.run(
          image: image,
          style: style,
        ),
      );
}
