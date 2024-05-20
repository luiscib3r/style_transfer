import 'dart:js_interop';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:web/web.dart';

Future<void> saveImageToGallery(Uint8List image) async {
  const uuid = Uuid();
  final array = JSArray<JSAny>()..add(image.toJS);

  final blob = Blob(
    array,
    BlobPropertyBag(type: 'image/jpeg'),
  );

  final url = URL.createObjectURL(blob);

  HTMLAnchorElement()
    ..href = url
    ..setAttribute('download', '${uuid.v4()}.jpg')
    ..click()
    ..remove();
}
