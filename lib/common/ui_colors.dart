import 'package:flutter/material.dart';

class UIColor {
  static const primaryColor = Color(0xFF292929);
  static const accentColor = Color(0xFF1E1E1E);
  static const fontColor = Color(0xFFE8E8E8);
  static const bottomNavIconSelectColor = Color(0xFF1D7CBE);
  static const h1Color = bottomNavIconSelectColor;
  static const h2Color = fontColor;
  static const h3Color = Color(0xFF5E605F);
  static const formFontColor = Color(0xFFA9A9A9);
  static const historyFontColor = formFontColor;
  static const bottomNavIconNoSelColor = formFontColor;
  static const positivPositionColor = Color(0xFF7BBC7A);
  static const negativePositionColor = Color(0xFFDA362D);
  static const negativeHistoryStrok = Color(0xFFA75654);
  static const positiveHistoryStroke = Color(0xFF7CA97E);
  static const positiveHistoryGradient =
      LinearGradient(colors: [Color(0xFF242B2D), Color(0xFF2E3B36)]);
  static const negativeHistoryGradient =
      LinearGradient(colors: [Color(0xFF302A2E), Color(0xFF3B2E30)]);

  static const negativeProgress = Color(0xFF49373A);
  static const negativeProgressSTR = Color(0xFF88666D);

  static const positiveProgress = Color(0xFF2E3B36);
  static const positiveProgressSTR = Color(0xFF658175);

  static const List<BoxShadow> shadowBox = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.14),
      blurRadius: 1.0,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 1.0,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      blurRadius: 3.0,
      offset: Offset(0, 1),
    ),
  ];
}
