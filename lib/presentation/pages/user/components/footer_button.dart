import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  const FooterButton(
      {Key? key,
      required this.buttonCaption,
      this.onPressed,
      required this.text})
      : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  final String buttonCaption;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onPressed,
          child: Text(buttonCaption),
        ),
      ],
    );
  }
}
