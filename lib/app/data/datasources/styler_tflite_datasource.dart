import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:style_transfer/app/data/data.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class StylerDataSourceImpl extends StylerDataSource {
  StylerDataSourceImpl({
    required ImageDataSource imageDataSource,
  }) : _imageDataSource = imageDataSource;

  final ImageDataSource _imageDataSource;

  Interpreter? _predictionInterpreter;
  Interpreter? _transferInterpreter;

  @override
  Future<void> load({
    int? predictInterpreterAddress,
    int? transferInterpreterAddress,
  }) async {
    final predictionOptions = InterpreterOptions();
    final transferOptions = InterpreterOptions();

    // Use GPU Delegate
    // doesn't work on emulator
    if (Platform.isAndroid) {
      predictionOptions.addDelegate(GpuDelegateV2());
      transferOptions.addDelegate(GpuDelegateV2());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      predictionOptions.addDelegate(GpuDelegate());
      transferOptions.addDelegate(GpuDelegate());
    }

    // Load model from assets
    _predictionInterpreter =
        Interpreter.fromAddress(predictInterpreterAddress!);

    _transferInterpreter = Interpreter.fromAddress(transferInterpreterAddress!);

    log('Interpreters initialized');
  }

  @override
  Future<Uint8List> run({
    required Uint8List image,
    required Uint8List style,
  }) async {
    if (_predictionInterpreter == null || _transferInterpreter == null) {
      throw const InterpreterUnitializedException();
    }

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

    final imageMatrix = List.generate(
      imageImg.height,
      (y) => List.generate(
        imageImg!.width,
        (x) {
          final pixel = imageImg!.getPixel(x, y);
          return [pixel.r / 255, pixel.g / 255, pixel.b / 255];
        },
      ),
    );

    final styleMatrix = List.generate(
      styleImg.height,
      (y) => List.generate(
        styleImg!.width,
        (x) {
          final pixel = styleImg!.getPixel(x, y);
          return [pixel.r / 255, pixel.g / 255, pixel.b / 255];
        },
      ),
    );

    // [1, 256, 256, 3]
    final predictionInput = [styleMatrix];

    // [1, 1, 1, 100]
    final predictionOutput = [
      [
        [List<double>.filled(100, 0)],
      ]
    ];

    // Run prediction inference
    _predictionInterpreter!.run(predictionInput, predictionOutput);

    final transferInput = [
      // image [1, 384, 384, 3]
      [imageMatrix],
      // style [1, 1, 1, 100]
      predictionOutput,
    ];

    // [1, 384, 384, 3]
    final transferOutput = [
      List.generate(
        384,
        (index) => List.filled(384, [0.0, 0.0, 0.0]),
      ),
    ];

    _transferInterpreter!.runForMultipleInputs(
      transferInput,
      {0: transferOutput},
    );

    // Get first output tensor
    final result = transferOutput.first;

    final buffer = Uint8List.fromList(
      result
          .expand(
            (col) => col.expand(
              (pixel) => pixel.map((e) => (e * 255).toInt()),
            ),
          )
          .toList(),
    );

    // Build image from matrix
    final imageResult = encodeJpg(
      Image.fromBytes(
        width: 384,
        height: 384,
        bytes: buffer.buffer,
        numChannels: 3,
      ),
    );

    return imageResult.buffer.asUint8List();
  }
}
