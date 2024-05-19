part of 'styler_bloc.dart';

sealed class StylerState extends Equatable {
  const StylerState();

  @override
  List<Object?> get props => [];
}

class StylerInitial extends StylerState {
  const StylerInitial();
}

class StylerProcessingImage extends StylerState {
  const StylerProcessingImage({required this.image});

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}

class StylerProcessError extends StylerState {
  const StylerProcessError({
    required this.image,
    required this.failure,
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

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}
