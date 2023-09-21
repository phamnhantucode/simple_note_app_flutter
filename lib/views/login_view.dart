import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesbeginer/constants/routes.dart';
import 'package:mynotesbeginer/extension/buildcontext/loc.dart';
import 'package:mynotesbeginer/services/auth/auth_exceptions.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_event.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_state.dart';
import 'package:mynotesbeginer/utilities/dialogs/error_dialog.dart';
import 'package:mynotesbeginer/utilities/dialogs/loading_dialog.dart';

import '../services/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception != null) {
            if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(context, 'Wrong password');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Generic Auth Exception');
            } else if (state.exception is UserNotLoggedInAuthException) {
              await showErrorDialog(context, 'User not logged in');
            } else {
              await showErrorDialog(context, state.exception.toString());
            }
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(context.loc.my_title),
          ),
          body: Column(children: [
            TextField(
              controller: _email,
              autocorrect: true,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
            ),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(AuthEventLogin(
                      email: _email.text, password: _password.text));
                },
                child: const Text('Login')),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              child: const Text("Don't have account yet? Register"),
            )
          ])),
    );
  }
}
