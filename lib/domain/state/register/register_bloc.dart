import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trading/core/components/input_validator.dart';
import 'package:trading/core/components/validator/confirmpass.dart';
import 'package:trading/domain/usecases/user/register_new_user.dart';
import 'package:trading/domain/repository/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required UserRepository authRepository,
  })  : _registerUserEmail = RegisterUser(authRepository),
        super(const RegisterState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterPassConfirmChanged>(_onPassConfirmChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final RegisterUser _registerUserEmail;

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = InputEmail.dirty(event.email);
    emit(state.copyWith(
        email: email,
        status:
            FormValidate.status([email, state.passConfirm, state.password])));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = InputPassword.dirty(event.password);
    final confirm = InputConfirm.dirty(state.passConfirm.value, password.value);
    emit(state.copyWith(
        password: password,
        passConfirm: confirm,
        status: FormValidate.status([state.email, password, confirm])));
  }

  void _onPassConfirmChanged(
    RegisterPassConfirmChanged event,
    Emitter<RegisterState> emit,
  ) {
    final confirm = InputConfirm.dirty(event.passConfirm, state.password.value);
    emit(state.copyWith(
        passConfirm: confirm,
        status: FormValidate.status([state.email, state.password, confirm])));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.status == FormValidStatus.valid) {
      emit(state.copyWith(status: FormValidStatus.submitInProgress));
      final respons = await _registerUserEmail(UserEmailPassword(
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
