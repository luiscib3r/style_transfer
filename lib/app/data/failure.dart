part of 'result.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {
  const UnknownFailure(this.exception);

  final Exception exception;

  @override
  List<Object?> get props => [exception];
}

class ImageDecodeFailure extends Failure {
  const ImageDecodeFailure();
}

class ImageResizeFailure extends Failure {
  const ImageResizeFailure();
}
