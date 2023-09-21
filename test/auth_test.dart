import 'package:mynotesbeginer/services/auth/auth_exceptions.dart';
import 'package:mynotesbeginer/services/auth/auth_user.dart';
import 'package:test/test.dart';
import 'package:mynotesbeginer/services/auth/auth_provider.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with ', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize is less than 2 second',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test(
      'Create user should delegate to logIn function',
      () async {
        final badEmailUser = provider.createUser(
          email: 'foo',
          password: 'password',
        );
        expect(badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()));

        final badPasswordUser = provider.createUser(
          email: 'foo@bar.com',
          password: 's',
        );
        expect(badPasswordUser,
            throwsA(const TypeMatcher<WrongPasswordAuthException>()));

        final user = await provider.createUser(
          email: 'foo@bar.com',
          password: 'foobar',
        );
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );

    test(
      'Should be able to logout and login again',
      () async {
        await provider.logout();
        await provider.login(
          email: 'foo@bar.com',
          password: 'foobar',
        );
        final user = provider.currentUser;
        expect(user, isNotNull);
      },
    );
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') {
      if (password == 'foobar') {
        const user = AuthUser(email: 'email', isEmailVerified: false, id: 'my_id');
        _user = user;
        return Future.value(user);
      } else {
        throw WrongPasswordAuthException();
      }
    } else {
      throw UserNotFoundAuthException();
    }
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    _user = null;
  }
}
