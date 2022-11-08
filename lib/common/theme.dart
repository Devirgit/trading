import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: UIColor.primaryColor,
  appBarTheme: const AppBarTheme(
    color: UIColor.accentColor,
  ),
  scaffoldBackgroundColor: UIColor.primaryColor,
  bottomAppBarColor: UIColor.accentColor,
  dividerTheme: const DividerThemeData(thickness: 0.1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: UIColor.accentColor,
    selectedItemColor: UIColor.bottomNavIconSelectColor,
    unselectedItemColor: UIColor.bottomNavIconNoSelColor,
  ),
);
