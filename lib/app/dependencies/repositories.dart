import 'package:style_transfer/app/app.dart';

final styleTransferRepository = RepositoryProvider(
  lazy: false,
  create: (context) => StyleTransferRepository(
    imageDataSource: context.read(),
  ),
);
