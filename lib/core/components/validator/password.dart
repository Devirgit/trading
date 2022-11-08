import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/validator/input.dart';

class InputPassword extends InputValidator<String?, String> {
  const InputPassword.pure() : super.pure('');
  const InputPassword.dirty([super.value = '']) : super.dirty();

// 8 characters, one uppercase one lowercase letter
  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  String? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '') ? null : UItext.stringTextFild;
  }
}
