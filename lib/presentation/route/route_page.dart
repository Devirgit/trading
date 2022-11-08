import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NaviPageType {
  material,
  cupertino,
  fadeTransition,
  slideTransition,
  slideRightTransition,
  slideLeftTransition,
  slideTopTransition,
  scaleTransition,
  noTransition,
}

class NaviPage extends Page {
  const NaviPage({
    LocalKey? key,
    String? name,
    required this.child,
    this.title,
    this.type = NaviPageType.material,
    this.routeBuilder,
    this.fullScreenDialog = false,
    this.opaque = true,
  }) : super(key: key, name: name);

  static const notFound = NaviPage(
    key: ValueKey('not-found'),
    title: 'Not found',
    child: Scaffold(body: Center(child: Text('Not found'))),
  );

  final Widget child;
  final String? title;
  final NaviPageType type;
  final Route Function(
      BuildContext context, RouteSettings settings, Widget child)? routeBuilder;
  final bool fullScreenDialog;
  final bool opaque;

  @override
  Route createRoute(BuildContext context) {
    if (routeBuilder != null) {
      return routeBuilder!(context, this, child);
    }
    switch (type) {
      case NaviPageType.cupertino:
        return CupertinoPageRoute(
          title: title,
          fullscreenDialog: fullScreenDialog,
          settings: this,
          builder: (context) => child,
        );
      case NaviPageType.fadeTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      case NaviPageType.slideTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: animation.drive(
                Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                    .chain(CurveTween(curve: Curves.ease))),
            child: child,
          ),
        );
      case NaviPageType.slideRightTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: animation.drive(
                Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
                    .chain(CurveTween(curve: Curves.ease))),
            child: child,
          ),
        );
      case NaviPageType.slideLeftTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: animation.drive(
                Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
                    .chain(CurveTween(curve: Curves.ease))),
            child: child,
          ),
        );
      case NaviPageType.slideTopTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: animation.drive(
                Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                    .chain(CurveTween(curve: Curves.ease))),
            child: child,
          ),
        );
      case NaviPageType.scaleTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      case NaviPageType.noTransition:
        return PageRouteBuilder(
          fullscreenDialog: fullScreenDialog,
          opaque: opaque,
          settings: this,
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );
      default:
        return MaterialPageRoute(
          fullscreenDialog: fullScreenDialog,
          settings: this,
          builder: (context) => child,
        );
    }
  }
}
