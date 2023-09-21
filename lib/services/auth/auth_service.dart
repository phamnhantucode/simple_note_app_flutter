import 'package:mynotesbeginer/services/auth/auth_user.dart';
import 'package:mynotesbeginer/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();
  
  @override
  Future<void> initialize() => provider.initialize();
}
