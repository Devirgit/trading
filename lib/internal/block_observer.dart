import 'package:trading/logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    Logging.error({
      'bloc': bloc.toString(),
      'error': error.toString(),
      'srackTrack': stackTrace
    });
    super.onError(bloc, error, stackTrace);
  }
}
