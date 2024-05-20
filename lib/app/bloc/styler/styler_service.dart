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
    final currentState = state;

    if (currentState is StylerImageProcessed) {
      emit(StylerProcessingImage(image: currentState.image));

      final result = await _repository.rotateLeft(
        image: currentState.image,
      );

      switch (result) {
        case ResultSuccess(data: final image):
          emit(StylerImageProcessed(image: image));
        case ResultFailure(failure: final failure):
          emit(StylerProcessError(image: currentState.image, failure: failure));
      }
    }
  }

  Future<void> _rotateImageRight(
    StylerRotateImageRight event,
    Emitter<StylerState> emit,
  ) async {
    final currentState = state;

    if (currentState is StylerImageProcessed) {
      emit(StylerProcessingImage(image: currentState.image));
      final result = await _repository.rotateRight(
        image: currentState.image,
      );

      switch (result) {
        case ResultSuccess(data: final image):
          emit(StylerImageProcessed(image: image));
        case ResultFailure(failure: final failure):
          emit(StylerProcessError(image: currentState.image, failure: failure));
      }
    }
  }

  Future<void> _filterSelected(
    StylerFilterSelected event,
    Emitter<StylerState> emit,
  ) async {
    final currentState = state;

    if (currentState is StylerImageProcessed) {
      emit(StylerProcessingImage(image: currentState.image));

      final result = await _repository.run(
        image: currentState.image,
        style: event.filter,
      );

      switch (result) {
        case ResultSuccess(data: final image):
          emit(StylerImageProcessed(image: image));
        case ResultFailure(failure: final failure):
          emit(StylerProcessError(image: currentState.image, failure: failure));
      }
    }
  }

  @override
  void onChange(Change<StylerState> change) {
    super.onChange(change);
    emitState(change.nextState);
  }
}
