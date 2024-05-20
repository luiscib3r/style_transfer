import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:style_transfer/app/data/data.dart';

class StylerDataSourceImpl extends StylerDataSource {
  StylerDataSourceImpl({
    required ImageDataSource imageDataSource,
  }) : _imageDataSource = imageDataSource;

  final ImageDataSource _imageDataSource;

  late final String baseUrl;

  @override
  Future<void> load({
    int? predictInterpreterAddress,
    int? transferInterpreterAddress,
    String? baseUrl,
  }) async {
    this.baseUrl = baseUrl!;
  }

  @override
  Future<Uint8List> run({
    required Uint8List image,
    required Uint8List style,
  }) async {
    var imageImg = decodeImage(image);
    var styleImg = decodeImage(style);

    if (imageImg == null || styleImg == null) {
      throw const ImageDecodeException();
    }

    if (imageImg.width != 384 || imageImg.height != 384) {
      final newImage =
          await _imageDataSource.resizeImage(image: image, size: 384);
      imageImg = decodeImage(newImage);
      if (imageImg == null) {
        throw const ImageDecodeException();
      }
    }

    if (styleImg.width != 256 || styleImg.height != 256) {
      final newStyle =
          await _imageDataSource.resizeImage(image: style, size: 256);
      styleImg = decodeImage(newStyle);
      if (styleImg == null) {
        throw const ImageDecodeException();
      }
    }

    final imageBytes = encodeJpg(imageImg);
    final styleBytes = encodeJpg(styleImg);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/run'),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.jpg',
      ),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'style',
        styleBytes,
        filename: 'style.jpg',
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    return response.stream.toBytes();
  }
}
