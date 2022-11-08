import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/internal/app.dart';
import 'package:trading/internal/block_observer.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/internal/injection/register.dart';
import 'package:trading/logging/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseLogConfig.platformOptions);

  Bloc.observer = AppBlocObserver();
  Dependency.init();
  await Hive.initFlutter();
  await Di.get<AppState>().initAppState();
  runApp(const trading());
}
