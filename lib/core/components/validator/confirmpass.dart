import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/validator/input.dart';

class InputConfirm extends InputValidator<String?, String> {
  const InputConfirm.pure([this.password = ''])
      : super.pure(
          '',
        );
  const InputConfirm.dirty([super.value = '', this.password = ''])
      : super.dirty();
  final String? password;

  @override
  String? validator(String? value) {
    return value == password && value != '' ? null : UItext.confirmPassErr;
  }
}
