import 'package:trading/common/icons.dart';
import 'package:trading/common/ui_text.dart';
import 'package:flutter/material.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.child,
    required this.selectPageIndex,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final int selectPageIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(UIIcon.portfolio),
              label: UItext.portfolio,
            ),
            BottomNavigationBarItem(
              icon: Icon(UIIcon.history),
              label: UItext.history,
            ),
            BottomNavigationBarItem(
              icon: Icon(UIIcon.report),
              label: UItext.report,
            ),
            BottomNavigationBarItem(
              icon: Icon(UIIcon.profile),
              label: UItext.profile,
            ),
          ],
          currentIndex: selectPageIndex,
          onTap: onSelect,
        ));
  }
}
