import 'package:firebase_auth/firebase_auth.dart';

/// Authentication service using Firebase Auth (email & password).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user == null) {
      throw FirebaseAuthException(
        code: 'signup-failed',
        message: 'Signup failed. Please try again.',
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Maps [FirebaseAuthException.code] to short, user-facing copy.
  static String userFacingMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address does not look valid.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email. Try signing in.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      default:
        return e.message?.isNotEmpty == true
            ? e.message!
            : 'Something went wrong. Please try again.';
    }
  }
}
