import 'dart:async';

import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/price_entity.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/repository/app_state_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'app_state_event.dart';

class AppState {
  AppState({required AppStateRepository repository})
      : _appStateRepository = repository;

  final AppStateRepository _appStateRepository;
  late String path;
  late StreamController<AppStateEvent> _appStateStream;

  String get initPath => path;

  set initPath(String val) {
    _appStateRepository.savePath(val);
  }

  Future<void> initAppState() async {
    path = await _appStateRepository.getPath();
    _appStateStream = StreamController<AppStateEvent>.broadcast();
    return SynchronousFuture(null);
  }

  void add(AppStateEvent event) {
    if (_appStateStream.hasListener) {
      _appStateStream.add(event);
    }
  }

  Stream<T> on<T>() {
    if (T == dynamic) {
      return _appStateStream.stream as Stream<T>;
    } else {
      return _appStateStream.stream.where((event) => event is T).cast<T>();
    }
  }

  Stream<AppStateEvent> get appState async* {
    yield* _appStateStream.stream;
  }

  void dispose() {
    _appStateStream.close();
  }
}
