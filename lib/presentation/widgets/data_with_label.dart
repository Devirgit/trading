import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

const TextStyle _constLabelStyle =
    TextStyle(color: UIColor.formFontColor, fontSize: 12.0);
const TextStyle _constDataStyle = TextStyle(
    color: UIColor.fontColor, fontSize: 14.0, fontWeight: FontWeight.w600);

class DataWithLabel extends StatelessWidget {
  const DataWithLabel(
      {Key? key,
      required this.label,
      required this.data,
      this.dataStyle,
      this.labelStyle})
      : super(key: key);

  final String data;
  final String label;
  final TextStyle? dataStyle;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: labelStyle ?? _constLabelStyle,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          data,
          style: dataStyle ?? _constDataStyle,
        ),
      ],
    );
  }
}
