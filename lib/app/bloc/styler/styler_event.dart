part of 'styler_bloc.dart';

sealed class StylerEvent extends Equatable {
  const StylerEvent();

  @override
  List<Object> get props => [];
}

class StylerImageSelected extends StylerEvent {
  const StylerImageSelected({required this.image});

  final Uint8List image;

  @override
  List<Object> get props => [image];
}

class StylerRotateImageLeft extends StylerEvent {
  const StylerRotateImageLeft();
}

class StylerRotateImageRight extends StylerEvent {
  const StylerRotateImageRight();
}

class StylerFilterSelected extends StylerEvent {
  const StylerFilterSelected({required this.filter});

  final Uint8List filter;

  @override
  List<Object> get props => [filter];
}
