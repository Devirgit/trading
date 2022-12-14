part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterPassConfirmChanged extends RegisterEvent {
  const RegisterPassConfirmChanged(this.passConfirm);

  final String passConfirm;

  @override
  List<Object> get props => [passConfirm];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
