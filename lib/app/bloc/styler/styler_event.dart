part of 'styler_bloc.dart';

enum StylerEventType {
  imageSelected,
  rotateImageLeft,
  rotateImageRight,
  filterSelected;

  factory StylerEventType.from(String type) {
    switch (type) {
      case 'imageSelected':
        return StylerEventType.imageSelected;
      case 'rotateImageLeft':
        return StylerEventType.rotateImageLeft;
      case 'rotateImageRight':
        return StylerEventType.rotateImageRight;
      case 'filterSelected':
        return StylerEventType.filterSelected;
      default:
        throw Exception('Unknown event type: $type');
    }
  }

  String get name {
    switch (this) {
      case StylerEventType.imageSelected:
        return 'imageSelected';
      case StylerEventType.rotateImageLeft:
        return 'rotateImageLeft';
      case StylerEventType.rotateImageRight:
        return 'rotateImageRight';
      case StylerEventType.filterSelected:
        return 'filterSelected';
    }
  }
}

sealed class StylerEvent extends Equatable {
  const StylerEvent();

  factory StylerEvent.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;

    final type = StylerEventType.from(map['type'] as String);

    return switch (type) {
      StylerEventType.imageSelected => StylerImageSelected.decode(data),
      StylerEventType.rotateImageLeft => const StylerRotateImageLeft(),
      StylerEventType.rotateImageRight => const StylerRotateImageRight(),
      StylerEventType.filterSelected => StylerFilterSelected.decode(data),
    };
  }

  String get encode => switch (this) {
        final StylerImageSelected event => event.encode,
        final StylerRotateImageLeft event => event.encode,
        final StylerRotateImageRight event => event.encode,
        final StylerFilterSelected event => event.encode,
      };

  @override
  List<Object> get props => [];
}

class StylerImageSelected extends StylerEvent {
  const StylerImageSelected({required this.image});

  factory StylerImageSelected.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;
    final image = bytesFromJson(map['image'] as String);

    return StylerImageSelected(image: image);
  }

  @override
  String get encode {
    final map = <String, dynamic>{
      'image': bytesToJson(image),
      'type': StylerEventType.imageSelected.name,
    };

    return json.encode(map);
  }

  final Uint8List image;

  @override
  List<Object> get props => [image];
}

class StylerRotateImageLeft extends StylerEvent {
  const StylerRotateImageLeft();

  @override
  String get encode {
    final map = <String, dynamic>{
      'type': StylerEventType.rotateImageLeft.name,
    };

    return json.encode(map);
  }
}

class StylerRotateImageRight extends StylerEvent {
  const StylerRotateImageRight();

  @override
  String get encode {
    final map = <String, dynamic>{
      'type': StylerEventType.rotateImageRight.name,
    };

    return json.encode(map);
  }
}

class StylerFilterSelected extends StylerEvent {
  const StylerFilterSelected({required this.filter});

  factory StylerFilterSelected.decode(String data) {
    final map = json.decode(data) as Map<String, dynamic>;
    final filter = bytesFromJson(map['filter'] as String);

    return StylerFilterSelected(filter: filter);
  }

  @override
  String get encode {
    final map = <String, dynamic>{
      'filter': bytesToJson(filter),
      'type': StylerEventType.filterSelected.name,
    };

    return json.encode(map);
  }

  final Uint8List filter;

  @override
  List<Object> get props => [filter];
}
