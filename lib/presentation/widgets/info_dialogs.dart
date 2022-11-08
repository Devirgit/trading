import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class InfoDialogs {
  static Future<void> beginProcess(BuildContext context, [String? title]) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIColor.accentColor,
          title: title == null
              ? null
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: UIColor.formFontColor, fontSize: 14),
                ),
          content: const SizedBox(
              height: 50, child: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }

  static endProcess(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void snackBar(BuildContext context, String? message, {Key? key}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        content: Text(
          message ?? '',
          style: const TextStyle(color: UIColor.h2Color),
        ),
        backgroundColor: UIColor.accentColor,
      ),
    );
  }
}
