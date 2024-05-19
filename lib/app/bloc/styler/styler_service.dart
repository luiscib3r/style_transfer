part of 'styler_bloc.dart';

abstract class StylerService extends Bloc<StylerEvent, StylerState> {
  StylerService() : super(const StylerInitial()) {
    _subscription = onAddEvent.listen(add);
  }

  late final StreamSubscription<StylerEvent> _subscription;

  Stream<StylerEvent> get onAddEvent;

  void emitState(StylerState state);

  @override
  void onChange(Change<StylerState> change) {
    super.onChange(change);
    emitState(change.nextState);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
