import 'dart:async';
import 'dart:developer';

import 'package:style_transfer/app/app.dart';

abstract class BaseRepository {
  const BaseRepository();

  Future<Result<T>> process<T extends Object>({
    required FutureOr<T> Function() action,
  }) async {
    try {
      final data = await action();
      return ResultSuccess(data);
    } on ImageResizeException {
      return const ResultFailure(ImageResizeFailure());
    } on ImageDecodeException {
      return const ResultFailure(ImageDecodeFailure());
    } on Exception catch (e) {
      log(e.toString(), name: runtimeType.toString());
      return ResultFailure(UnknownFailure(e));
    }
  }
}
