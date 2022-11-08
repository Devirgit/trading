import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      this.height = 40,
      this.width = 280,
      this.color = UIColor.primaryColor,
      required this.caption,
      required this.onClick})
      : super(key: key);
  final double width;
  final double height;
  final String caption;
  final VoidCallback onClick;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
        decoration: BoxDecoration(
            boxShadow: UIColor.shadowBox,
            borderRadius: BorderRadius.circular(10)),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
              backgroundColor: MaterialStateProperty.all<Color>(color)),
          onPressed: onClick,
          child: Text(caption.toUpperCase()),
        ),
      ),
    );
  }
}
