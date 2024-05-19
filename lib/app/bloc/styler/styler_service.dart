part of 'styler_bloc.dart';

abstract class StylerService extends Bloc<StylerEvent, StylerState> {
  StylerService({
    required StyleTransferRepository repository,
  })  : _repository = repository,
        super(const StylerInitial()) {
    on<StylerImageSelected>(_imageSelected);
  }

  final StyleTransferRepository _repository;

  void emitState(StylerState state);

  Future<void> _imageSelected(
    StylerImageSelected event,
    Emitter<StylerState> emit,
  ) async {
    emit(StylerProcessingInputImage(image: event.image));

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

  @override
  void onChange(Change<StylerState> change) {
    super.onChange(change);
    emitState(change.nextState);
  }
}
