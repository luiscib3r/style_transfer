import 'dart:typed_data';

import 'package:style_transfer/app/data/datasources/datasources.dart';

class StylerDataSourceImpl extends StylerDataSource {
  const StylerDataSourceImpl({
    required ImageDataSource imageDataSource,
  }) : _imageDataSource = imageDataSource;

  final ImageDataSource _imageDataSource;

  @override
  Future<void> load({
    int? predictInterpreterAddress,
    int? transferInterpreterAddress,
  }) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> run({required Uint8List image, required Uint8List style}) {
    // TODO: implement run
    throw UnimplementedError();
  }
}
