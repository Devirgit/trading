import 'dart:math';

class UID {
  int generate() {
    final date = DateTime.now();
    final rng = Random();
    final int radX = (rng.nextInt(955333) + date.microsecond) ^
        (rng.nextInt(799010) + date.microsecond);
    final String result = '${date.year - 2020}' //2
        '${date.month.toString().padLeft(2, '0')}' //01-12
        '${date.day.toString().padLeft(2, '0')}' //01-28
        '${date.hour.toString().padLeft(2, '0')}' //00-23
        '${date.minute.toString().padLeft(2, '0')}' //00-59
        '${date.second.toString().padLeft(2, '0')}' //00-59
        '${radX.toString().padLeft(6, '0')}'; // 999999
    return int.parse(result);
  }
}
