part of 'filter_bloc.dart';

enum FilterEventType {
  loadFilters,
  addFilter;

  factory FilterEventType.from(String type) {
    switch (type) {
      case 'loadFilters':
        return FilterEventType.loadFilters;
      case 'addFilter':
        return FilterEventType.addFilter;
      default:
        throw Exception('Unknown event type: $type');
    }
  }

  String get name {
    switch (this) {
      case FilterEventType.loadFilters:
        return 'loadFilters';
      case FilterEventType.addFilter:
        return 'addFilter';
    }
  }
}

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  factory FilterEvent.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final type = FilterEventType.from(map['type'] as String);

    return switch (type) {
      FilterEventType.loadFilters => FilterLoadFilters.decode(data),
      FilterEventType.addFilter => FilterAddFilter.decode(data),
    };
  }

  String get encode => switch (this) {
        final FilterLoadFilters event => event.encode,
        final FilterAddFilter event => event.encode,
      };

  @override
  List<Object?> get props => [];
}

class FilterLoadFilters extends FilterEvent {
  const FilterLoadFilters(this.filters);

  factory FilterLoadFilters.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final filters =
        (map['filters'] as List).cast<String>().map(bytesFromJson).toList();

    return FilterLoadFilters(filters);
  }

  @override
  String get encode {
    final filters = this.filters.map(bytesToJson).toList();

    return json.encode({
      'type': FilterEventType.loadFilters.name,
      'filters': filters,
    });
  }

  final List<Uint8List> filters;

  @override
  List<Object?> get props => [filters];
}

class FilterAddFilter extends FilterEvent {
  const FilterAddFilter({
    required this.image,
  });

  factory FilterAddFilter.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;
    final image = bytesFromJson(map['image'] as String);

    return FilterAddFilter(image: image);
  }

  @override
  String get encode {
    return json.encode({
      'type': FilterEventType.addFilter.name,
      'image': bytesToJson(image),
    });
  }

  final Uint8List image;

  @override
  List<Object?> get props => [image];
}
