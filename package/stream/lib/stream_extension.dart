import 'dart:async';

extension TransformByHandlers<S> on Stream<S> {
  Stream<T> transformByHandlers<T>(
      {void Function(S, EventSink<T>)? onData,
      void Function(Object, StackTrace, EventSink<T>)? onError,
      void Function(EventSink<T>)? onDone}) {
    final handleData = onData ?? _defaultHandleData;
    final handleError = onError ?? _defaultHandleError;
    final handleDone = onDone ?? _defaultHandleDone;

    var controller = isBroadcast
        ? StreamController<T>.broadcast(sync: true)
        : StreamController<T>(sync: true);

    StreamSubscription<S>? subscription;
    controller.onListen = () {
      assert(subscription == null);
      var valuesDone = false;
      subscription = listen((value) => handleData(value, controller),
          onError: (Object error, StackTrace stackTrace) {
        handleError(error, stackTrace, controller);
      }, onDone: () {
        valuesDone = true;
        handleDone(controller);
      });
      if (!isBroadcast) {
        controller
          ..onPause = subscription!.pause
          ..onResume = subscription!.resume;
      }
      controller.onCancel = () {
        var toCancel = subscription;
        subscription = null;
        if (!valuesDone) return toCancel!.cancel();
        return null;
      };
    };
    return controller.stream;
  }

  static void _defaultHandleData<S, T>(S value, EventSink<T> sink) {
    sink.add(value as T);
  }

  static void _defaultHandleError<T>(
      Object error, StackTrace stackTrace, EventSink<T> sink) {
    sink.addError(error, stackTrace);
  }

  static void _defaultHandleDone<T>(EventSink<T> sink) {
    sink.close();
  }
}

extension Switch<T> on Stream<T> {
  Stream<S> switchMap<S>(Stream<S> Function(T) convert) {
    return map(convert).switchLatest();
  }
}

/// A utility to take events from the most recent sub stream.
extension SwitchLatest<T> on Stream<Stream<T>> {
  Stream<T> switchLatest() {
    var controller = isBroadcast
        ? StreamController<T>.broadcast(sync: true)
        : StreamController<T>(sync: true);

    controller.onListen = () {
      StreamSubscription<T>? innerSubscription;
      var outerStreamDone = false;

      final outerSubscription = listen(
          (innerStream) {
            innerSubscription?.cancel();
            innerSubscription = innerStream.listen(controller.add,
                onError: controller.addError, onDone: () {
              innerSubscription = null;
              if (outerStreamDone) controller.close();
            });
          },
          onError: controller.addError,
          onDone: () {
            outerStreamDone = true;
            if (innerSubscription == null) controller.close();
          });
      if (!isBroadcast) {
        controller
          ..onPause = () {
            innerSubscription?.pause();
            outerSubscription.pause();
          }
          ..onResume = () {
            innerSubscription?.resume();
            outerSubscription.resume();
          };
      }
      controller.onCancel = () {
        var cancels = [
          if (!outerStreamDone) outerSubscription.cancel(),
          if (innerSubscription != null) innerSubscription!.cancel(),
        ]
          // Handle opt-out nulls
          ..removeWhere((Object? f) => f == null);
        if (cancels.isEmpty) return null;
        return Future.wait(cancels).then((_) => null);
      };
    };
    return controller.stream;
  }
}

extension RateLimit<T> on Stream<T> {
  T _dropPrevious<T>(T element, _) => element;

  Stream<T> throttle(Duration duration, {bool trailing = false}) =>
      trailing ? _throttleTrailing(duration) : _throttle(duration);

  Stream<T> _throttleTrailing(Duration duration) {
    Timer? timer;
    T? pending;
    var hasPending = false;
    var isDone = false;

    return transformByHandlers(onData: (data, sink) {
      void onTimer() {
        if (hasPending) {
          sink.add(pending as T);
          if (isDone) {
            sink.close();
          } else {
            timer = Timer(duration, onTimer);
            hasPending = false;
            pending = null;
          }
        } else {
          timer = null;
        }
      }

      if (timer == null) {
        sink.add(data);
        timer = Timer(duration, onTimer);
      } else {
        hasPending = true;
        pending = data;
      }
    }, onDone: (sink) {
      isDone = true;
      if (hasPending) return; // Will be closed by timer.
      sink.close();
      timer?.cancel();
      timer = null;
    });
  }

  Stream<T> _throttle(Duration duration) {
    Timer? timer;

    return transformByHandlers(onData: (data, sink) {
      if (timer == null) {
        sink.add(data);
        timer = Timer(duration, () {
          timer = null;
        });
      }
    });
  }

  Stream<T> debounce(Duration duration,
          {bool leading = false, bool trailing = true}) =>
      _debounceAggregate(duration, _dropPrevious,
          leading: leading, trailing: trailing);

  Stream<S> _debounceAggregate<S>(
      Duration duration, S Function(T element, S? soFar) collect,
      {required bool leading, required bool trailing}) {
    Timer? timer;
    S? soFar;
    var hasPending = false;
    var shouldClose = false;
    var emittedLatestAsLeading = false;

    return transformByHandlers(onData: (value, sink) {
      void emit() {
        sink.add(soFar as S);
        soFar = null;
        hasPending = false;
      }

      timer?.cancel();
      soFar = collect(value, soFar);
      hasPending = true;
      if (timer == null && leading) {
        emittedLatestAsLeading = true;
        emit();
      } else {
        emittedLatestAsLeading = false;
      }
      timer = Timer(duration, () {
        if (trailing && !emittedLatestAsLeading) emit();
        if (shouldClose) sink.close();
        timer = null;
      });
    }, onDone: (EventSink<S> sink) {
      if (hasPending && trailing) {
        shouldClose = true;
      } else {
        timer?.cancel();
        sink.close();
      }
    });
  }
}
