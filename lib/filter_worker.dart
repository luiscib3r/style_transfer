import 'package:style_transfer/app/bloc/filter/worker/filter_bloc_worker.dart';
import 'package:style_transfer/app/data/datasources/image_datasource.dart';
import 'package:style_transfer/app/data/datasources/styler_api_datasource.dart';
import 'package:style_transfer/app/data/repositories/style_transfer_repository.dart';

void main() {
  FilterServiceImpl(
    repository: StyleTransferRepository(
      imageDataSource: const ImageDataSource(),
      stylerDataSource: StylerDataSourceImpl(
        imageDataSource: const ImageDataSource(),
      ),
    )..load(baseUrl: const String.fromEnvironment('baseUrl')),
  );
}
