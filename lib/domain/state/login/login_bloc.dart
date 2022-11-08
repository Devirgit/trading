import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trading/core/components/input_validator.dart';
import 'package:trading/domain/usecases/user/login_user_email.dart';
import 'package:trading/domain/repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository authRepository,
  })  : _loginUserEmail = LoginUserEmail(authRepository),
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUserEmail _loginUserEmail;

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = InputEmail.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: FormValidate.status([email, state.password]),
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = InputPassword.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: FormValidate.status([state.email, password]),
    ));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == FormValidStatus.valid) {
      emit(state.copyWith(status: FormValidStatus.submitInProgress));
      final respons = await _loginUserEmail(UserEmailPassword(
          email: state.email.value, password: state.password.value));
      respons.result(
          (error) => emit(state.copyWith(
              status: FormValidStatus.submitFailure,
              errorMessage: error.message)), (user) {
        emit(state.copyWith(status: FormValidStatus.submitSuccess));
      });
    } else {
      if (state.status == FormValidStatus.invalid) {
        emit(state.copyWith(status: FormValidStatus.error));
      }
    }
  }
}
