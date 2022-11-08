class ViewFormat {
  static int _countPersistent(double patern) {
    final strPatern = patern.toString();
    if (strPatern.indexOf('e') < 1) {
      final count = strPatern.length - strPatern.indexOf('.') - 1;
      if (count < 2) return 2;
      return count > 8 ? 8 : count;
    }
    return 8;
  }

  static String formatCostDisplay(double cost, {double? patern}) {
    late int fixed;
    if (patern == null) {
      fixed = _countPersistent(cost);
    } else {
      fixed = _countPersistent(patern);
    }
    String line = _doubleToString(cost, fixed: fixed);
    if (line.isNotEmpty) {
      int separate = line.indexOf('.');
      String hstr = "";
      String lstr = "";
      if (separate > 0) {
        int endcopy;
        if (line.length < (fixed + separate + 1)) {
          endcopy = line.length;
        } else {
          endcopy = fixed + separate + 1;
        }
        lstr = line.substring(separate, endcopy);
        var regExp = RegExp(r'[1-9]');
        if (regExp.allMatches(lstr).isEmpty) {
          lstr = "";
        }

        hstr = line.substring(0, separate);
      } else {
        hstr = line;
      }
      if (hstr.length > 3) {
        var regExp = RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))');
        hstr = hstr.replaceAll(regExp, ' ');
      }
      if ((hstr.length > 2) && (lstr.length > 6)) {
        lstr = lstr.substring(0, 5);
      }
      if ((hstr.length > 4) && (lstr.length > 4)) {
        lstr = lstr.substring(0, 3);
      }
      return hstr + lstr;
    } else {
      return "";
    }
  }

  static String _doubleToString(double value, {int fixed = 8}) {
    final verbose = value.toStringAsFixed(fixed);
    String trimmed = verbose;
    for (var i = verbose.length - 1; i > 0; i--) {
      if (trimmed[i] != '0' && trimmed[i] != '.' || !trimmed.contains('.')) {
        break;
      }
      trimmed = trimmed.substring(0, i);
    }
    return trimmed;
  }

  static String formatingDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year.toString()}";
  }

  static String formatingTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
