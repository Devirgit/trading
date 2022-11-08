import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class BoxDecor extends StatelessWidget {
  const BoxDecor({Key? key, required this.child}) : super(key: key);

  BoxDecor.header(
      {Key? key,
      required Widget iconHeader,
      required Widget header,
      required Widget action,
      required Widget child})
      : this(
            key: key,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconHeader,
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: header),
                    const SizedBox(
                      width: 5,
                    ),
                    action
                  ],
                ),
                child,
              ],
            ));

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: UIColor.accentColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: UIColor.shadowBox),
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}
