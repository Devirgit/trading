import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/validator/input.dart';

class InputEmail extends InputValidator<String?, String> {
  const InputEmail.pure() : super.pure('');
  const InputEmail.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  String? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '') ? null : UItext.emailError;
  }
}
