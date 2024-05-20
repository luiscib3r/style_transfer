import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<void> saveImageToGallery(Uint8List image) async {
  await ImageGallerySaver.saveImage(image);
}
