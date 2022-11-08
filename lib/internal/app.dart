import 'package:trading/common/theme.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/internal/injection/register.dart';
import 'package:trading/presentation/route/go_routing.dart';
import 'package:trading/domain/state/auth/auth_bloc.dart';
import 'package:trading/internal/dependencies/repository_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Trading extends StatelessWidget {
  Trading({Key? key}) : super(key: key);

  final routConfig = Routing(
    onTapNaviBar: (value) => Di.get<AppState>().initPath = value,
  );

  @override
  Widget build(BuildContext context) {
    final router = routConfig.initRouter(Di.get<AppState>().initPath);

    return RepositoryProvider(
      create: (context) => RepositoryModule.inst,
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: Di.get(),
        ),
        child: BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              Dependency.authorizationChange(context, state.user);
              routConfig.isAuth = state.user.isNotEmpty;
            },
            child: InitApp(
              dispose: () => Di.get<AppState>().dispose(),
              child: MaterialApp.router(
                title: UItext.apptitle,
                theme: darkTheme,
                restorationScopeId: 'trading',
                debugShowCheckedModeBanner: false,
                routerConfig: router,
              ),
            )),
      ),
    );
  }
}

class InitApp extends StatefulWidget {
  const InitApp({required this.child, this.init, this.dispose, Key? key})
      : super(key: key);

  final Widget child;
  final VoidCallback? init;
  final VoidCallback? dispose;

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  @override
  void initState() {
    super.initState();
    if (widget.init != null) {
      widget.init;
    }
  }

  @override
  void dispose() {
    if (widget.dispose != null) {
      widget.dispose;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
