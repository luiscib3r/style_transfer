import 'dart:convert';
import 'dart:typed_data';

export 'filter/filter_bloc.dart';
export 'styler/styler_bloc.dart';

Uint8List bytesFromJson(String json) => base64.decode(json);
String bytesToJson(Uint8List image) => base64.encode(image);
