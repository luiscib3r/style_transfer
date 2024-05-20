/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/banner.png
  AssetGenImage get banner => const AssetGenImage('assets/images/banner.png');

  /// List of all assets
  List<AssetGenImage> get values => [banner];
}

class $AssetsModelsGen {
  const $AssetsModelsGen();

  /// File path: assets/models/.gitkeep
  String get gitkeep => 'assets/models/.gitkeep';

  /// File path: assets/models/magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite
  String get magentaArbitraryImageStylizationV1256Int8Prediction1 =>
      'assets/models/magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite';

  /// File path: assets/models/magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite
  String get magentaArbitraryImageStylizationV1256Int8Transfer1 =>
      'assets/models/magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite';

  /// List of all assets
  List<String> get values => [
        gitkeep,
        magentaArbitraryImageStylizationV1256Int8Prediction1,
        magentaArbitraryImageStylizationV1256Int8Transfer1
      ];
}

class $AssetsStylesGen {
  const $AssetsStylesGen();

  /// File path: assets/styles/style0.jpg
  AssetGenImage get style0 => const AssetGenImage('assets/styles/style0.jpg');

  /// File path: assets/styles/style1.jpg
  AssetGenImage get style1 => const AssetGenImage('assets/styles/style1.jpg');

  /// File path: assets/styles/style10.jpg
  AssetGenImage get style10 => const AssetGenImage('assets/styles/style10.jpg');

  /// File path: assets/styles/style11.jpg
  AssetGenImage get style11 => const AssetGenImage('assets/styles/style11.jpg');

  /// File path: assets/styles/style12.jpg
  AssetGenImage get style12 => const AssetGenImage('assets/styles/style12.jpg');

  /// File path: assets/styles/style13.jpg
  AssetGenImage get style13 => const AssetGenImage('assets/styles/style13.jpg');

  /// File path: assets/styles/style14.jpg
  AssetGenImage get style14 => const AssetGenImage('assets/styles/style14.jpg');

  /// File path: assets/styles/style15.jpg
  AssetGenImage get style15 => const AssetGenImage('assets/styles/style15.jpg');

  /// File path: assets/styles/style16.jpg
  AssetGenImage get style16 => const AssetGenImage('assets/styles/style16.jpg');

  /// File path: assets/styles/style17.jpg
  AssetGenImage get style17 => const AssetGenImage('assets/styles/style17.jpg');

  /// File path: assets/styles/style18.jpg
  AssetGenImage get style18 => const AssetGenImage('assets/styles/style18.jpg');

  /// File path: assets/styles/style19.jpg
  AssetGenImage get style19 => const AssetGenImage('assets/styles/style19.jpg');

  /// File path: assets/styles/style2.jpg
  AssetGenImage get style2 => const AssetGenImage('assets/styles/style2.jpg');

  /// File path: assets/styles/style20.jpg
  AssetGenImage get style20 => const AssetGenImage('assets/styles/style20.jpg');

  /// File path: assets/styles/style3.jpg
  AssetGenImage get style3 => const AssetGenImage('assets/styles/style3.jpg');

  /// File path: assets/styles/style4.jpg
  AssetGenImage get style4 => const AssetGenImage('assets/styles/style4.jpg');

  /// File path: assets/styles/style5.jpg
  AssetGenImage get style5 => const AssetGenImage('assets/styles/style5.jpg');

  /// File path: assets/styles/style6.jpg
  AssetGenImage get style6 => const AssetGenImage('assets/styles/style6.jpg');

  /// File path: assets/styles/style7.jpg
  AssetGenImage get style7 => const AssetGenImage('assets/styles/style7.jpg');

  /// File path: assets/styles/style8.jpg
  AssetGenImage get style8 => const AssetGenImage('assets/styles/style8.jpg');

  /// File path: assets/styles/style9.jpg
  AssetGenImage get style9 => const AssetGenImage('assets/styles/style9.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
        style0,
        style1,
        style10,
        style11,
        style12,
        style13,
        style14,
        style15,
        style16,
        style17,
        style18,
        style19,
        style2,
        style20,
        style3,
        style4,
        style5,
        style6,
        style7,
        style8,
        style9
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsModelsGen models = $AssetsModelsGen();
  static const $AssetsStylesGen styles = $AssetsStylesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
