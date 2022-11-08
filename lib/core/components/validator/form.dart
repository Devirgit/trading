import 'package:trading/core/components/validator/input.dart';

enum FormValidStatus {
  empty,
  init,
  valid,
  invalid,
  error,
  submitInProgress,
  submitSuccess,
  submitFailure,
  submitCanceled
}

extension FormValidStatusUtils on FormValidStatus {
  bool get isInvalid => this == FormValidStatus.invalid;

  bool get isSubmitInProgress => this == FormValidStatus.submitInProgress;
}

class FormValidate {
  static FormValidStatus status(List<InputValidator<String?, String>> inputs) {
    return inputs.every((element) => element.pure)
        ? FormValidStatus.empty
        : inputs.any((input) => input.error != null)
            ? FormValidStatus.invalid
            : FormValidStatus.valid;
  }
}
