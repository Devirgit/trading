import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class TextfieldWithLabel extends StatelessWidget {
  const TextfieldWithLabel(
      {Key? key,
      required this.label,
      required this.fieldName,
      this.hintText,
      this.initialValue,
      this.keyboardType,
      this.controller,
      this.onChange,
      this.focusNode,
      this.maxLength,
      this.error,
      this.labelTrailing,
      this.readOnly = false})
      : super(key: key);

  final String label;
  final Widget? labelTrailing;
  final String fieldName;
  final String? hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool readOnly;
  final ValueChanged<String>? onChange;
  final FocusNode? focusNode;
  final int? maxLength;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final labelWidget = labelTrailing != null
        ? Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      color: UIColor.formFontColor, fontSize: 14.0),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                labelTrailing!,
              ],
            ))
        : Align(
            alignment: Alignment.topLeft,
            child: Text(
              label,
              style:
                  const TextStyle(color: UIColor.formFontColor, fontSize: 14.0),
            ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: [
          labelWidget,
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            restorationId: fieldName,
            controller: controller,
            keyboardType: keyboardType,
            initialValue: initialValue,
            readOnly: readOnly,
            onChanged: onChange,
            focusNode: focusNode,
            maxLength: maxLength,
            decoration: InputDecoration(
                errorText: error,
                border: const OutlineInputBorder(),
                hintText: hintText),
          )
        ],
      ),
    );
  }
}
