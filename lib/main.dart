import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesbeginer/constants/routes.dart';
import 'package:mynotesbeginer/helpers/loading/loading_screen.dart';
import 'package:mynotesbeginer/services/auth/auth_service.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_event.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_state.dart';
import 'package:mynotesbeginer/services/auth/firebase_auth_provider.dart';
import 'package:mynotesbeginer/views/counter_view.dart';
import 'package:mynotesbeginer/views/login_view.dart';
import 'package:mynotesbeginer/views/notes/create_update_note_view.dart';
import 'package:mynotesbeginer/views/notes/note_view.dart';
import 'package:mynotesbeginer/views/register_view.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: BlocProvider(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText ?? 'Please wait a moment');

        } else {
          LoadingScreen().hide();
        }

      },
      builder: (context, state) {
        
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
    // return FutureBuilder(
    //   future: AuthService.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         final user = FirebaseAuth.instance.currentUser;
    //         if (user != null) {
    //           return const NotesView();
    //         }
    //         return const LoginView();
    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // );
  }
}
