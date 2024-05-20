part of 'styler_bloc.dart';

enum StylerStateType {
  initial,
  processingImage,
  processError,
  imageProcessed,
  imageWithFilter;

  factory StylerStateType.from(String type) {
    switch (type) {
      case 'initial':
        return StylerStateType.initial;
      case 'processingImage':
        return StylerStateType.processingImage;
      case 'processError':
        return StylerStateType.processError;
      case 'imageProcessed':
        return StylerStateType.imageProcessed;
      case 'imageWithFilter':
        return StylerStateType.imageWithFilter;
      default:
        throw Exception('Unknown state type: $type');
    }
  }

  String get name {
    switch (this) {
      case StylerStateType.initial:
        return 'initial';
      case StylerStateType.processingImage:
        return 'processingImage';
      case StylerStateType.processError:
        return 'processError';
      case StylerStateType.imageProcessed:
        return 'imageProcessed';
      case StylerStateType.imageWithFilter:
        return 'imageWithFilter';
    }
  }
}

sealed class StylerState extends Equatable {
  const StylerState();

  factory StylerState.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final type = StylerStateType.from(map['type'] as String);

    return switch (type) {
      StylerStateType.initial => const StylerInitial(),
      StylerStateType.processingImage => StylerProcessingImage.decode(data),
      StylerStateType.processError => StylerProcessError.decode(data),
      StylerStateType.imageProcessed => StylerImageProcessed.decode(data),
      StylerStateType.imageWithFilter => StylerImageWithFilter.decode(data),
    };
  }

  String get encode => switch (this) {
        final StylerInitial state => state.encode,
        final StylerProcessingImage state => state.encode,
        final StylerProcessError state => state.encode,
        final StylerImageProcessed state => state.encode,
        final StylerImageWithFilter state => state.encode,
      };

  @override
  List<Object?> get props => [];
}

class StylerInitial extends StylerState {
  const StylerInitial();

  @override
  String get encode => json.encode({
        'type': StylerStateType.initial.name,
      });
}

class StylerProcessingImage extends StylerState {
  const StylerProcessingImage({required this.image});

  factory StylerProcessingImage.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final image = bytesFromJson(map['image'] as String);

    return StylerProcessingImage(image: image);
  }

  @override
  String get encode => json.encode({
        'type': StylerStateType.processingImage.name,
        'image': bytesToJson(image),
      });

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}

class StylerProcessError extends StylerState {
  const StylerProcessError({
    required this.image,
    required this.failure,
  });

  factory StylerProcessError.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final image = bytesFromJson(map['image'] as String);
    final failure = Failure.decode(map['failure'] as String);

    return StylerProcessError(image: image, failure: failure);
  }

  @override
  String get encode => json.encode({
        'type': StylerStateType.processError.name,
        'image': bytesToJson(image),
        'failure': failure.encode,
      });

  final Uint8List image;
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class StylerImageProcessed extends StylerState {
  const StylerImageProcessed({
    required this.image,
  });

  factory StylerImageProcessed.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final image = bytesFromJson(map['image'] as String);

    return StylerImageProcessed(image: image);
  }

  @override
  String get encode => json.encode({
        'type': StylerStateType.imageProcessed.name,
        'image': bytesToJson(image),
      });

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}

class StylerImageWithFilter extends StylerState {
  const StylerImageWithFilter({
    required this.image,
    required this.original,
  });

  factory StylerImageWithFilter.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final image = bytesFromJson(map['image'] as String);
    final original = bytesFromJson(map['original'] as String);

    return StylerImageWithFilter(image: image, original: original);
  }

  @override
  String get encode => json.encode({
        'type': StylerStateType.imageWithFilter.name,
        'image': bytesToJson(image),
        'original': bytesToJson(original),
      });

  final Uint8List image;
  final Uint8List original;

  @override
  List<Object?> get props => [image, original];
}
