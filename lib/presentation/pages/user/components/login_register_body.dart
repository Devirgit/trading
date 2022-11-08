import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:flutter/material.dart';

class LoginRegisterBody extends StatelessWidget {
  const LoginRegisterBody(
      {Key? key, required this.inputWidgets, required this.footerWidget})
      : super(key: key);
  final Widget inputWidgets;
  final Widget footerWidget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        const SizedBox(
          height: 50.0,
        ),
        const Center(
            child: Text(
          UItext.apptitle,
          style: TextStyle(color: UIColor.fontColor, fontSize: 50.0),
        )),
        const Spacer(
          flex: 1,
        ),
        inputWidgets,
        const Spacer(
          flex: 2,
        ),
        footerWidget,
      ]),
    );
  }
}
