import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesbeginer/constants/routes.dart';
import 'package:mynotesbeginer/services/auth/auth_exceptions.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_event.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_state.dart';
import 'package:mynotesbeginer/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception != null) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Weak password');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email already in use');
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
            title: const Text('Register'),
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
                  context.read<AuthBloc>().add(
                        AuthEventRegister(
                          email: _email.text,
                          password: _password.text,
                        ),
                      );
                },
                child: const Text('Register')),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogout(),
                    );
              },
              child: const Text("Already have account? Login"),
            )
          ])),
    );
  }
}
