part of 'filter_bloc.dart';

sealed class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FilterLoading extends FilterState {
  const FilterLoading({
    this.filters = const <Uint8List>[],
  });

  final List<Uint8List> filters;

  @override
  List<Object?> get props => [filters];
}

class FilterDone extends FilterState {
  const FilterDone({
    required this.filters,
  });

  final List<Uint8List> filters;

  @override
  List<Object?> get props => [filters];
}
