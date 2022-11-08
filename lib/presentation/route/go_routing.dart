import 'package:trading/presentation/pages/user/auth_page.dart';
import 'package:trading/presentation/pages/user/registry_page.dart';
import 'package:trading/presentation/route/route_config.dart';
import 'package:trading/presentation/widgets/scaffold_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class Routing {
  Routing({this.onTapNaviBar});

  String redirectUrl = '/';
  final String redirectLoginUrl = '/login';
  bool _isAuth = false;

  final List<String> navBarPath = ['/', 'history', 'report', 'profile'];

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');
  final ValueChanged<String>? onTapNaviBar;

  set isAuth(bool value) {
    _isAuth = value;
    _updateRoute();
  }

  late GoRouter router;

  void _onNavBarTap(int index) {
    final appPath = index != 0 ? '/${navBarPath[index]}' : navBarPath[index];
    router.go(appPath);
    if (onTapNaviBar != null) {
      onTapNaviBar!(appPath);
    }
  }

  GoRouter initRouter([String? initPath]) {
    router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        routes: [
          ShellRoute(
              navigatorKey: _shellNavigatorKey,
              builder: (context, state, child) {
                final path = Uri.parse(router.location).pathSegments;
                final index = navBarPath.indexOf(path.isEmpty ? '/' : path[0]);

                if (index == -1 || path.length > 1) {
                  return child;
                }

                return ScaffoldWithNavBar(
                  selectPageIndex: index,
                  onSelect: (value) => _onNavBarTap(value),
                  child: child,
                );
              },
              routes: [
                GoRoute(
                    path: navBarPath[0],
                    pageBuilder: (context, state) {
                      return RoutePageConfig.rootPage(context);
                    },
                    redirect: (context, state) =>
                        _redirection(state.location, true),
                    routes: [
                      GoRoute(
                        path: 'add/:catUID',
                        pageBuilder: (context, state) {
                          final catUID = int.tryParse(state.params['catUID']!);

                          return catUID != null
                              ? RoutePageConfig.addSymbolPage(catUID)
                              : RoutePageConfig.notFoundPage;
                        },
                      ),
                      GoRoute(
                          path: navBarPath[1],
                          pageBuilder: (context, state) {
                            return RoutePageConfig.historyPage(
                                symbolID: int.tryParse(
                                    state.queryParams['uid'] ?? '0'));
                          },
                          routes: [
                            GoRoute(
                              path: 'search',
                              pageBuilder: (context, state) =>
                                  RoutePageConfig.historySymbolSearchPage,
                            )
                          ]),
                      GoRoute(
                          path: navBarPath[2],
                          pageBuilder: (context, state) =>
                              RoutePageConfig.reportPage(),
                          routes: [
                            GoRoute(
                              path: ':categoryIndex',
                              pageBuilder: (context, state) {
                                final DateTime? start = DateTime.tryParse(
                                    state.queryParams['start'] ?? '');
                                final DateTime? end = DateTime.tryParse(
                                    state.queryParams['end'] ?? '');
                                return RoutePageConfig.detailReportPage(
                                    int.tryParse(
                                        state.params['categoryIndex'] ?? ''),
                                    start,
                                    end);
                              },
                            ),
                          ]),
                      GoRoute(
                        path: navBarPath[3],
                        pageBuilder: (context, state) =>
                            RoutePageConfig.profilePage(),
                      ),
                    ]),
              ]),
          GoRoute(
            path: '/login',
            builder: (context, state) => const AuthPage(),
            redirect: (context, state) => _redirection(state.location, false),
          ),
          GoRoute(
              path: '/register',
              builder: (context, state) => const RegisterPage(),
              redirect: (context, state) =>
                  _redirection(state.location, false)),
        ],
        errorPageBuilder: (context, state) => RoutePageConfig.notFoundPage,
        initialLocation: initPath);

    return router;
  }

  Future<String?> _redirection(String requestUrl, bool requiredAuth) {
    if (!_isAuth && requiredAuth) {
      redirectUrl = requestUrl;
      return SynchronousFuture(redirectLoginUrl);
    }

    if (_isAuth && !requiredAuth) {
      return SynchronousFuture(redirectUrl);
    }
    return SynchronousFuture(null);
  }

  void _updateRoute() {
    router.refresh();
  }
}
