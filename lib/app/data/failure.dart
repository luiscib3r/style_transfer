part of 'result.dart';

enum FailureTypes {
  unknown,
  imageDecode,
  imageResize,
  interpreter;

  factory FailureTypes.from(String type) {
    switch (type) {
      case 'unknown':
        return FailureTypes.unknown;
      case 'imageDecode':
        return FailureTypes.imageDecode;
      case 'imageResize':
        return FailureTypes.imageResize;
      case 'interpreter':
        return FailureTypes.interpreter;
      default:
        throw Exception('Unknown failure type: $type');
    }
  }

  String get name {
    switch (this) {
      case FailureTypes.unknown:
        return 'unknown';
      case FailureTypes.imageDecode:
        return 'imageDecode';
      case FailureTypes.imageResize:
        return 'imageResize';
      case FailureTypes.interpreter:
        return 'interpreter';
    }
  }
}

sealed class Failure extends Equatable {
  const Failure();

  factory Failure.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final type = FailureTypes.from(map['type'] as String);

    return switch (type) {
      FailureTypes.unknown => UnknownFailure.decode(data),
      FailureTypes.imageDecode => const ImageDecodeFailure(),
      FailureTypes.imageResize => const ImageResizeFailure(),
      FailureTypes.interpreter => const InterpreterFailure(),
    };
  }

  String get encode => switch (this) {
        final UnknownFailure failure => failure.encode,
        final ImageDecodeFailure failure => failure.encode,
        final ImageResizeFailure failure => failure.encode,
        final InterpreterFailure failure => failure.encode,
      };

  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {
  const UnknownFailure(this.exception);

  factory UnknownFailure.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final exception = Exception(map['exception'] as String);

    return UnknownFailure(exception);
  }

  @override
  String get encode => json.encode({
        'type': FailureTypes.unknown.name,
        'exception': exception.toString(),
      });

  final Exception exception;

  @override
  List<Object?> get props => [exception];
}

class ImageDecodeFailure extends Failure {
  const ImageDecodeFailure();

  @override
  String get encode => json.encode({
        'type': FailureTypes.imageDecode.name,
      });
}

class ImageResizeFailure extends Failure {
  const ImageResizeFailure();

  @override
  String get encode => json.encode({
        'type': FailureTypes.imageResize.name,
      });
}

class InterpreterFailure extends Failure {
  const InterpreterFailure();

  @override
  String get encode => json.encode({
        'type': FailureTypes.interpreter.name,
      });
}
