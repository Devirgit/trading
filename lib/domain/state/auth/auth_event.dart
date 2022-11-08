part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class AuthStatusChanged extends AuthEvent {
  final AuthenticationStatus status;

  const AuthStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}

class AuthLogoutRequest extends AuthEvent {}

class AuthAttemptAutoLogin extends AuthEvent {}
