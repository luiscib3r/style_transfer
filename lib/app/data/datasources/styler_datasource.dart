import 'dart:typed_data';

abstract class StylerDataSource {
  const StylerDataSource();

  Future<void> load({
    int? predictInterpreterAddress,
    int? transferInterpreterAddress,
    String? baseUrl,
  });

  Future<Uint8List> run({
    required Uint8List image,
    required Uint8List style,
  });
}
