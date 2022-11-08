import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/presentation/pages/report/components/choic_period_menu.dart';
import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:flutter/material.dart';

typedef SelectPeriod = void Function(DateTime start, DateTime end);

class BoxReportDecoration extends StatelessWidget {
  const BoxReportDecoration({
    Key? key,
    required this.titleHeader,
    required this.icon,
    required this.child,
    required this.onChanged,
    this.endPeriod,
    this.startPeriod,
    this.empty = false,
    this.currency = '',
  }) : super(key: key);

  final Widget child;
  final String titleHeader;
  final Widget icon;
  final SelectPeriod onChanged;
  final DateTime? startPeriod;
  final DateTime? endPeriod;
  final bool empty;
  final String currency;

  @override
  Widget build(BuildContext context) {
    Widget header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleHeader,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: UIColor.h1Color,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              UItext.period,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: UIColor.h3Color,
              ),
            ),
            Builder(builder: (context) {
              if (empty) {
                return const Text(UItext.changePeriod,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: UIColor.h1Color,
                    ));
              } else {
                return ChoicPeriodMenu(
                  startPeriod: startPeriod,
                  endPeriod: endPeriod,
                  onChanged: (value) => onChanged(value.sart, value.end),
                );
              }
            }),
          ],
        )
      ],
    );

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: BoxDecor.header(
            iconHeader: icon,
            header: header,
            action: Padding(
                padding: const EdgeInsets.only(top: 37, left: 5, right: 5),
                child: Text(
                  currency.toUpperCase(),
                  style: const TextStyle(
                    color: UIColor.h3Color,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.right,
                )),
            child: child));
  }
}
