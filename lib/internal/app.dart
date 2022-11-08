import 'package:trading/common/theme.dart';
import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/internal/injection/register.dart';
import 'package:trading/presentation/forms/form_buy_sale.dart';
import 'package:trading/presentation/route/go_routing.dart';
import 'package:trading/domain/state/auth/auth_bloc.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/internal/dependencies/repository_module.dart';

import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class trading extends StatelessWidget {
  tradingAll({Key? key}) : super(key: key);

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

