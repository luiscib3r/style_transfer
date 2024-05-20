part of 'styler_bloc.dart';

abstract class StylerService extends Bloc<StylerEvent, StylerState> {
  StylerService({
    required StyleTransferRepository repository,
  })  : _repository = repository,
        super(const StylerInitial()) {
    on<StylerImageSelected>(_imageSelected);
    on<StylerRotateImageLeft>(_rotateImageLeft);
    on<StylerRotateImageRight>(_rotateImageRight);
    on<StylerFilterSelected>(_filterSelected);
  }

  final StyleTransferRepository _repository;

  Future<void> load({
    int? predictInterpreterAddress,
    int? transferInterpreterAddress,
  }) =>
      _repository.load(
        predictInterpreterAddress: predictInterpreterAddress,
        transferInterpreterAddress: transferInterpreterAddress,
      );

  void emitState(StylerState state);

  Uint8List? get _image => switch (state) {
        StylerImageProcessed(image: final image) => image,
        StylerImageWithFilter(image: final image) => image,
        StylerProcessError(image: final image) => image,
        _ => null,
      };

  Future<void> _imageSelected(
    StylerImageSelected event,
    Emitter<StylerState> emit,
  ) async {
    emit(StylerProcessingImage(image: event.image));

    final result = await _repository.resizeImage(
      image: event.image,
      size: 384,
    );

    switch (result) {
      case ResultSuccess(data: final image):
        emit(StylerImageProcessed(image: image));
      case ResultFailure(failure: final failure):
        emit(StylerProcessError(image: event.image, failure: failure));
    }
  }

  Future<void> _rotateImageLeft(
    StylerRotateImageLeft event,
    Emitter<StylerState> emit,
  ) async {
    final image = _image;

    final original = switch (state) {
      StylerImageWithFilter(original: final image) => image,
      _ => null,
    };

    if (image != null) {
      emit(StylerProcessingImage(image: image));

      final result = await _repository.rotateLeft(
        image: image,
      );

      switch (result) {
        case ResultSuccess(data: final image):
          emit(
            original != null
                ? StylerImageWithFilter(image: image, original: original)
                : StylerImageProcessed(image: image),
          );
        case ResultFailure(failure: final failure):
          emit(StylerProcessError(image: image, failure: failure));
      }
    }
  }

  Future<void> _rotateImageRight(
    StylerRotateImageRight event,
    Emitter<StylerState> emit,
  ) async {
    final image = _image;

    final original = switch (state) {
      StylerImageWithFilter(original: final image) => image,
      _ => null,
    };

    if (image != null) {
      emit(StylerProcessingImage(image: image));

      final result = await _repository.rotateRight(
        image: image,
      );

      switch (result) {
        case ResultSuccess(data: final image):
          emit(
            original != null
                ? StylerImageWithFilter(image: image, original: original)
                : StylerImageProcessed(image: image),
          );
        case ResultFailure(failure: final failure):
          emit(StylerProcessError(image: image, failure: failure));
      }
    }
  }

  Future<void> _filterSelected(
    StylerFilterSelected event,
    Emitter<StylerState> emit,
  ) async {
    final image = switch (state) {
      StylerImageProcessed(image: final image) => image,
      StylerImageWithFilter(original: final image) => image,
      StylerProcessError(image: final image) => image,
      _ => null,
    };

    if (image != null) {
      emit(StylerProcessingImage(image: image));

      final result = await _repository.run(
        image: image,
        style: event.filter,
      );

      switch (result) {
        case ResultSuccess(data: final imageFiltered):
          emit(StylerImageWithFilter(image: imageFiltered, original: image));
        case ResultFailure(failure: final failure):
          emit(StylerProcessError(image: image, failure: failure));
      }
    }
  }

  @override
  void onChange(Change<StylerState> change) {
    super.onChange(change);
    emitState(change.nextState);
  }
}
