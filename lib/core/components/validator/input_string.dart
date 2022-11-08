import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/validator/input.dart';

class InputString extends InputValidator<String?, String> {
  const InputString.pure() : super.pure('');
  const InputString.dirty([super.value = '']) : super.dirty();

  static final _stringRegExp = RegExp(r'^[а-яА-ЯёЁa-zA-Z0-9-\., ]+$');

  @override
  String? validator(String? value) {
    return _stringRegExp.hasMatch(value ?? '') ? null : UItext.stringTextFild;
  }
}
