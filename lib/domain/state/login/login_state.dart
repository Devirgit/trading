part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const InputEmail.pure(),
    this.password = const InputPassword.pure(),
    this.status = FormValidStatus.empty,
    this.errorMessage,
  });

  final InputEmail email;
  final InputPassword password;
  final FormValidStatus status;
  final String? errorMessage;

  LoginState copyWith({
    InputEmail? email,
    InputPassword? password,
    FormValidStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
