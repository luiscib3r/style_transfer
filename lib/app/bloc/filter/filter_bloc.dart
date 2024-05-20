import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/app/bloc/filter/worker/filter_bloc_worker.dart';

part 'filter_event.dart';
part 'filter_service.dart';
part 'filter_state.dart';

abstract class FilterBloc extends Cubit<FilterState> {
  FilterBloc() : super(const FilterLoading());

  void listen() {
    _subscription = onEmitState.listen(emit);
  }

  late final StreamSubscription<FilterState> _subscription;

  Stream<FilterState> get onEmitState;

  Future<void> loadFilters() async {
    if (state is FilterDone) {
      return;
    }

    emit(const FilterLoading());

    for (final asset in Assets.styles.values) {
      try {
        final filter = await rootBundle.load(asset.path);

        final filters = (state as FilterLoading).filters;

        emit(FilterLoading(filters: [...filters, filter.buffer.asUint8List()]));
      } catch (e) {
        log(e.toString());
      }
    }

    final filters = (state as FilterLoading).filters;
    add(FilterLoadFilters(filters));
  }

  void addFilter(Uint8List image) => add(FilterAddFilter(image: image));

  void add(FilterEvent event);

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
