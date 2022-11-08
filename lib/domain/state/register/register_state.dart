part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const InputEmail.pure(),
    this.password = const InputPassword.pure(),
    this.passConfirm = const InputConfirm.pure(),
    this.status = FormValidStatus.empty,
    this.errorMessage,
  });

  final InputEmail email;
  final InputPassword password;
  final InputConfirm passConfirm;
  final FormValidStatus status;
  final String? errorMessage;

  RegisterState copyWith({
    InputEmail? email,
    InputPassword? password,
    InputConfirm? passConfirm,
    FormValidStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      passConfirm: passConfirm ?? this.passConfirm,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [email, password, passConfirm, status];
}
