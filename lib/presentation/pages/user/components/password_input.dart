import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
    this.inputID = 'Password',
    this.error,
    this.onChange,
  }) : super(key: key);
  final String? error;
  final ValueChanged<String>? onChange;
  final String inputID;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      restorationId: widget.inputID,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: InkWell(
          child: obscure
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
          onTap: () {
            obscure = !obscure;
            setState(() {});
          },
        ),
        hintText: widget.inputID,
        errorText: widget.error,
      ),
      onChanged: widget.onChange,
    );
  }
}
