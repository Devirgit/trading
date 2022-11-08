import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/repository/user_repository.dart';
import 'package:trading/domain/usecases/user/attempt_auto_login.dart';
import 'package:trading/domain/usecases/user/logout_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required UserRepository authRepository,
  })  : _authRepository = authRepository,
        _logOutUser = LogOutUser(authRepository),
        _attemptAutoLoginIn = AttemptAutoLoginIn(authRepository),
        super(const AuthState.unauthenticated()) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLogoutRequest>(_onAuthLogoutRequested);
    _userSubscription =
        _authRepository.userChange.listen((user) => add(AuthUserChanged(user)));
    _attemptAutoLoginIn(true);
  }

  final UserRepository _authRepository;
  final LogOutUser _logOutUser;
  final AttemptAutoLoginIn _attemptAutoLoginIn;
  late StreamSubscription<UserEntity> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _authRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user.isNotEmpty) {
      emit(AuthState.authenticated(event.user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequest event, Emitter<AuthState> emit) async {
    final respons = await _logOutUser(state.user);
    respons.result((error) => emit(const AuthState.unknown()),
        (succes) => emit(const AuthState.unauthenticated()));
  }
}
