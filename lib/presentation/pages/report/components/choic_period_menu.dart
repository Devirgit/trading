import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/forms/form_select_period.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:flutter/material.dart';

enum ChoicPeriod { year, mounth, week, interval }

class ChoicPeriodMenu extends StatefulWidget {
  const ChoicPeriodMenu(
      {Key? key, required this.onChanged, this.endPeriod, this.startPeriod})
      : super(key: key);

  final ValueChanged<DatePeriod> onChanged;
  final DateTime? startPeriod;
  final DateTime? endPeriod;

  @override
  State<ChoicPeriodMenu> createState() => _ChoicPeriodMenuState();
}

class _ChoicPeriodMenuState extends State<ChoicPeriodMenu> {
  late ChoicPeriod _choicPeriod;
  String _interval = '';
  DateTime? _startPeriod;
  DateTime? _endPeriod;

  void _menuItemSelect(BuildContext context, ChoicPeriod value) {
    final now = DateTime.now();
    switch (value) {
      case ChoicPeriod.year:
        widget.onChanged(
            DatePeriod(DateTime(now.year - 1, now.month, now.day), now));
        break;
      case ChoicPeriod.mounth:
        widget.onChanged(
            DatePeriod(DateTime(now.year, now.month - 1, now.day), now));
        break;

      case ChoicPeriod.week:
        widget.onChanged(
            DatePeriod(DateTime(now.year, now.month, now.day - 7), now));
        break;

      case ChoicPeriod.interval:
        Forms.show(
          context,
          FormSelectPeriod(
              startPeriod: _startPeriod,
              endPeriod: _endPeriod,
              onChanged: (date) {
                _startPeriod = date.sart;
                _endPeriod = date.end;
                widget.onChanged(DatePeriod(date.sart, date.end));
                _interval =
                    "${ViewFormat.formatingDate(date.sart)} - ${ViewFormat.formatingDate(date.end)}";
                setState(() {
                  _choicPeriod = value;
                });
              }),
        );
        break;
    }
    if (value != ChoicPeriod.interval) {
      setState(() {
        _choicPeriod = value;
      });
    }
  }

  String _periodToString(BuildContext context, ChoicPeriod value) {
    return {
      ChoicPeriod.year: UItext.yaer,
      ChoicPeriod.mounth: UItext.mounth,
      ChoicPeriod.week: UItext.week,
      ChoicPeriod.interval: _interval,
    }[value]!;
  }

  ChoicPeriod _preparePeriod() {
    if (_startPeriod != null && _endPeriod != null) {
      if (_endPeriod!.difference(_startPeriod!).inDays == 7) {
        return ChoicPeriod.week;
      }

      DateTime compareDate =
          DateTime(_endPeriod!.year, _endPeriod!.month - 1, _endPeriod!.day);
      if (_startPeriod == compareDate) return ChoicPeriod.mounth;

      compareDate =
          DateTime(_endPeriod!.year - 1, _endPeriod!.month, _endPeriod!.day);
      if (_startPeriod == compareDate) return ChoicPeriod.year;

      _interval = "${ViewFormat.formatingDate(_startPeriod!)} -"
          " ${ViewFormat.formatingDate(_endPeriod!)}";
      return ChoicPeriod.interval;
    }
    return ChoicPeriod.mounth;
  }

  @override
  void initState() {
    super.initState();

    _startPeriod = widget.startPeriod;
    _endPeriod = widget.endPeriod;
    _choicPeriod = _preparePeriod();
  }

  void _initPeriod() {
    if (_startPeriod == null || _endPeriod == null) {
      _startPeriod ??= widget.startPeriod;
      _endPeriod ??= widget.endPeriod;
      _choicPeriod = _preparePeriod();
    }
  }

  @override
  Widget build(BuildContext context) {
    _initPeriod();

    return PopupMenuButton<ChoicPeriod>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      initialValue: _choicPeriod,
      tooltip: UItext.choicperiod,
      onSelected: (value) => _menuItemSelect(context, value),
      itemBuilder: (context) => <PopupMenuItem<ChoicPeriod>>[
        PopupMenuItem(
            value: ChoicPeriod.year,
            child: Text(_periodToString(context, ChoicPeriod.year))),
        PopupMenuItem(
            value: ChoicPeriod.mounth,
            child: Text(_periodToString(context, ChoicPeriod.mounth))),
        PopupMenuItem(
            value: ChoicPeriod.week,
            child: Text(_periodToString(context, ChoicPeriod.week))),
        const PopupMenuItem(
            value: ChoicPeriod.interval, child: Text(UItext.interval)),
      ],
      child: Text(
        _periodToString(context, _choicPeriod),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: UIColor.h1Color,
        ),
      ),
    );
  }
}
