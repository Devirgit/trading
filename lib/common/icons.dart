import 'package:flutter/widgets.dart';

class UIIcon {
  static const _fontFamily = 'trading';

  static const IconData category = IconData(0xe90b, fontFamily: _fontFamily);
  static const IconData history = IconData(0xe90f, fontFamily: _fontFamily);
  static const IconData profile = IconData(0xe910, fontFamily: _fontFamily);
  static const IconData portfolio = IconData(0xe911, fontFamily: _fontFamily);
  static const IconData report = IconData(0xe912, fontFamily: _fontFamily);

  static const IconData bank = IconData(0xe909, fontFamily: _fontFamily);
  static const IconData bankArrow = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData btc = IconData(0xe90a, fontFamily: _fontFamily);
  static const IconData eth = IconData(0xe90c, fontFamily: _fontFamily);
  static const IconData future = IconData(0xe90d, fontFamily: _fontFamily);
  static const IconData futureArrow = IconData(0xe90e, fontFamily: _fontFamily);
  static const IconData usd = IconData(0xe913, fontFamily: _fontFamily);
  static const IconData usdt = IconData(0xe914, fontFamily: _fontFamily);

  static const iconSet = [
    bank,
    bankArrow,
    btc,
    eth,
    future,
    futureArrow,
    usd,
    usdt
  ];
}
