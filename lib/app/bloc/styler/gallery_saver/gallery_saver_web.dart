// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

Future<void> saveImageToGallery(Uint8List image) async {
  const uuid = Uuid();
  final blob = Blob([image], 'image/jpg');

  final url = Url.createObjectUrlFromBlob(blob);

  AnchorElement(href: url)
    ..setAttribute('download', '${uuid.v4()}.jpg')
    ..click()
    ..remove();

  Url.revokeObjectUrl(url);
}
