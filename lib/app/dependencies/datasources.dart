import 'package:style_transfer/app/app.dart';

final imageDataSource =
    RepositoryProvider.value(value: const ImageDataSource());

final stylerDataSource = RepositoryProvider<StylerDataSource>(
  lazy: false,
  create: (context) => StylerTfLiteDataSource(
    imageDataSource: context.read(),
  ),
);
