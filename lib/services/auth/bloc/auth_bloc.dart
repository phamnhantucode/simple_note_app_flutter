import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesbeginer/services/auth/auth_provider.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_event.dart';
import 'package:mynotesbeginer/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(isLoading: true),
        ) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
          loadingText: 'Please wait while I log out',
        ));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventLogin>((event, emit) async {
      try {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        final user = await provider.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(null, isLoading: false));
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        emit(const AuthStateRegistering(null, isLoading: true));
        final user = await provider.createUser(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(e, isLoading: false));
      }
    });
  }
}
