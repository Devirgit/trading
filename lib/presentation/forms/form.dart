import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

typedef SuccessForm<Data> = Function(BuildContext formContext, Data? data);

class ModalForm extends StatelessWidget {
  const ModalForm({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: UIColor.accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 35,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: UIColor.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Forms {
  static show(BuildContext context, Widget form) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return form;
      },
    );
  }

  static close(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
