import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/input_validator.dart';
import 'package:trading/domain/state/register/register_bloc.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/pages/user/components/email_input.dart';
import 'package:trading/presentation/pages/user/components/footer_button.dart';
import 'package:trading/presentation/pages/user/components/login_register_body.dart';
import 'package:trading/presentation/pages/user/components/password_input.dart';
import 'package:trading/presentation/widgets/button.dart';
import 'package:trading/presentation/widgets/info_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocProvider(
        create: (_) => RegisterBloc(
          authRepository: Di.get(),
        ),
        child: const _BodyWidget(),
      )),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == FormValidStatus.submitFailure) {
            InfoDialogs.snackBar(
                context, state.errorMessage ?? UItext.registerError);
          }
        },
        child: LoginRegisterBody(
          inputWidgets: const _InputRegister(),
          footerWidget: FooterButton(
            buttonCaption: UItext.signin,
            text: UItext.yesAccount,
            onPressed: () {
              context.go('/login');
            },
          ),
        ));
  }
}

class _InputRegister extends StatelessWidget {
  const _InputRegister({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      _EmailInput(),
      SizedBox(
        height: 32.0,
      ),
      _PasswordInput(),
      SizedBox(
        height: 15,
      ),
      _ConfirmPassInput(),
      SizedBox(
        height: 65.0,
      ),
      _SubmitButton(),
    ]);
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? emailError;
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.email.isNotValid) {
          emailError = current.email.error;
        } else {
          emailError = null;
        }
        return ((current.email.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.email != previous.email));
      },
      builder: (context, state) {
        return EmailInput(
          error: emailError,
          onChange: (text) =>
              context.read<RegisterBloc>().add(RegisterEmailChanged(text)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? passError;
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.password.isNotValid) {
          passError = current.password.error;
        } else {
          passError = null;
        }

        return ((current.password.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.password.value != previous.password.value));
      },
      builder: (context, state) {
        return PasswordInput(
          error: passError,
          onChange: (text) =>
              context.read<RegisterBloc>().add(RegisterPasswordChanged(text)),
        );
      },
    );
  }
}

class _ConfirmPassInput extends StatelessWidget {
  const _ConfirmPassInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? confirmError;
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.passConfirm.isNotValid) {
          confirmError = current.passConfirm.error;
        } else {
          confirmError = null;
        }

        return ((current.passConfirm.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.passConfirm.value != previous.passConfirm.value));
      },
      builder: (context, state) {
        return PasswordInput(
          inputID: 'Confirm password',
          error: confirmError,
          onChange: (text) => context
              .read<RegisterBloc>()
              .add(RegisterPassConfirmChanged(text)),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmitInProgress
            ? const CircularProgressIndicator()
            : Button(
                caption: UItext.register,
                color: UIColor.accentColor,
                width: 250,
                onClick: () {
                  context.read<RegisterBloc>().add(const RegisterSubmitted());
                },
              );
      },
    );
  }
}
