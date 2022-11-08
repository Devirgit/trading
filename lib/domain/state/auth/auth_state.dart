part of 'auth_bloc.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthenticationStatus.unknown,
    this.user = UserEntity.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserEntity user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final UserEntity user;

  @override
  List<Object> get props => [status, user];
}
