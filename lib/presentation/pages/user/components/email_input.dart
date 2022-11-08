import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
    this.error,
    this.onChange,
  }) : super(key: key);
  final String? error;
  final ValueChanged<String>? onChange;
  @override
  Widget build(BuildContext context) {
    return TextField(
      restorationId: 'Email',
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          border: const OutlineInputBorder(),
          errorText: error,
          hintText: 'Email'),
      onChanged: onChange,
    );
  }
}
