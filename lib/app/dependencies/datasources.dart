import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/app/data/datasources/styler_tflite_datasource.dart'
    if (dart.library.html) 'package:style_transfer/app/data/datasources/styler_api_datasource.dart';

final imageDataSource =
    RepositoryProvider.value(value: const ImageDataSource());

final stylerDataSource = RepositoryProvider<StylerDataSource>(
  lazy: false,
  create: (context) => StylerDataSourceImpl(
    imageDataSource: context.read(),
  ),
);
