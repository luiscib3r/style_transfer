part of 'filter_bloc.dart';

abstract class FilterService extends Bloc<FilterEvent, FilterState> {
  FilterService({
    required StyleTransferRepository repository,
  })  : _repository = repository,
        super(const FilterLoading()) {
    on<FilterLoadFilters>(_loadFilters);
    on<FilterAddFilter>(_addFilter);
  }

  final StyleTransferRepository _repository;

  void emitState(FilterState state);

  Future<void> _loadFilters(
    FilterLoadFilters event,
    Emitter<FilterState> emit,
  ) async {
    emit(FilterDone(filters: event.filters));
  }

  Future<void> _addFilter(
    FilterAddFilter event,
    Emitter<FilterState> emit,
  ) async {
    if (state is FilterDone) {
      final filters = (state as FilterDone).filters;
      emit(FilterLoading(filters: filters));

      final result = await _repository.resizeImage(
        image: event.image,
        size: 256,
      );

      switch (result) {
        case ResultSuccess(data: final image):
          final filters = (state as FilterLoading).filters;
          emit(FilterDone(filters: [image, ...filters]));
        case ResultFailure():
          emit(FilterDone(filters: (state as FilterLoading).filters));
      }
    }
  }

  @override
  void onChange(Change<FilterState> change) {
    super.onChange(change);
    emitState(change.nextState);
  }
}
