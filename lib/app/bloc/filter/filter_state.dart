part of 'filter_bloc.dart';

enum FilterStateType {
  loading,
  done;

  factory FilterStateType.from(String type) {
    switch (type) {
      case 'loading':
        return FilterStateType.loading;
      case 'done':
        return FilterStateType.done;
      default:
        throw Exception('Unknown state type: $type');
    }
  }

  String get name {
    switch (this) {
      case FilterStateType.loading:
        return 'loading';
      case FilterStateType.done:
        return 'done';
    }
  }
}

sealed class FilterState extends Equatable {
  const FilterState();

  factory FilterState.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final type = FilterStateType.from(map['type'] as String);

    return switch (type) {
      FilterStateType.loading => FilterLoading.decode(data),
      FilterStateType.done => FilterDone.decode(data),
    };
  }

  String get encode => switch (this) {
        final FilterLoading state => state.encode,
        final FilterDone state => state.encode,
      };

  @override
  List<Object?> get props => [];
}

class FilterLoading extends FilterState {
  const FilterLoading({
    this.filters = const <Uint8List>[],
  });

  factory FilterLoading.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final filters =
        (map['filters'] as List).cast<String>().map(bytesFromJson).toList();

    return FilterLoading(filters: filters);
  }

  @override
  String get encode {
    final filters = this.filters.map(bytesToJson).toList();

    return json.encode({
      'type': FilterStateType.loading.name,
      'filters': filters,
    });
  }

  final List<Uint8List> filters;

  @override
  List<Object?> get props => [filters];
}

class FilterDone extends FilterState {
  const FilterDone({
    required this.filters,
  });

  factory FilterDone.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final filters =
        (map['filters'] as List).cast<String>().map(bytesFromJson).toList();

    return FilterDone(filters: filters);
  }

  @override
  String get encode {
    final filters = this.filters.map(bytesToJson).toList();

    return json.encode({
      'type': FilterStateType.done.name,
      'filters': filters,
    });
  }

  final List<Uint8List> filters;

  @override
  List<Object?> get props => [filters];
}
