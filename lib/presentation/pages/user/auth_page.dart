import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/input_validator.dart';
import 'package:trading/domain/state/login/login_bloc.dart';
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

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocProvider(
        create: (_) => LoginBloc(
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
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == FormValidStatus.submitFailure) {
            InfoDialogs.snackBar(
                context, state.errorMessage ?? UItext.notAuthorized);
          }
        },
        child: LoginRegisterBody(
          inputWidgets: const _InputAuth(),
          footerWidget: FooterButton(
            buttonCaption: UItext.register,
            text: UItext.notAccount,
            onPressed: () {
              context.go('/register');
            },
          ),
        ));
  }
}

class _InputAuth extends StatelessWidget {
  const _InputAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      _EmailInput(),
      SizedBox(
        height: 32.0,
      ),
      _PasswordInput(),
      SizedBox(
        height: 65.0,
      ),
      _SubmitButton(),
    ]);
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? emailError;
    return BlocBuilder<LoginBloc, LoginState>(
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
          onChange: (email) {
            context.read<LoginBloc>().add(LoginEmailChanged(email));
          },
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? passError;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.password.isNotValid) {
          passError = current.password.error;
        } else {
          passError = null;
        }

        return ((current.password.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.password != previous.password));
      },
      builder: (context, state) {
        return PasswordInput(
            error: passError,
            onChange: (password) {
              context.read<LoginBloc>().add(LoginPasswordChanged(password));
            });
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmitInProgress
            ? const CircularProgressIndicator()
            : Button(
                caption: UItext.signinBtn,
                color: UIColor.accentColor,
                width: 250,
                onClick: () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                },
              );
      },
    );
  }
}
