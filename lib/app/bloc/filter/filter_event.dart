part of 'filter_bloc.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class FilterLoadFilters extends FilterEvent {
  const FilterLoadFilters(this.filters);

  final List<Uint8List> filters;

  @override
  List<Object?> get props => [filters];
}

class FilterAddFilter extends FilterEvent {
  const FilterAddFilter({
    required this.image,
  });

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}
