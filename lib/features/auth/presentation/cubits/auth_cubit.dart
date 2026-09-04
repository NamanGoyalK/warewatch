import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  StreamSubscription<UserEntity?>? _sub;

  AuthCubit(this._repo) : super(AuthInitial()) {
    _sub = _repo.authStateChanges().listen((user) async {
      if (user != null) {
        await _syncUserToBackend();
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    }, onError: (e) => emit(AuthError(_friendlyMessage(e))));
  }

  Future<void> _syncUserToBackend() async {
    try {
      final fbUser = fb.FirebaseAuth.instance.currentUser;
      if (fbUser == null) return;

      final token = await fbUser.getIdToken();
      if (token == null) return;

      final baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080';

      await http.post(
        Uri.parse('$baseUrl/api/auth/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {}
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (email.trim().isEmpty) {
      emit(AuthError('Enter an email address to continue.'));
      return;
    }

    if (password.isEmpty) {
      emit(AuthError('Enter your password to continue.'));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _repo.signInWithEmail(email, password);
      if (user != null) {
        await _syncUserToBackend();
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    }
  }

  Future<void> registerWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    if (email.trim().isEmpty) {
      emit(AuthError('Enter an email address to continue.'));
      return;
    }

    if (password.isEmpty) {
      emit(AuthError('Create a password to continue.'));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _repo.registerWithEmail(
        email,
        password,
        displayName: displayName,
      );
      if (user != null) {
        await _syncUserToBackend();
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInWithGoogle();
      if (user != null) {
        await _syncUserToBackend();
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      emit(AuthError('Enter an email address to continue.'));
      return;
    }

    emit(AuthLoading());
    try {
      await _repo.sendPasswordResetEmail(email);
      emit(AuthPasswordResetSent(email));
    } catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  String _friendlyMessage(Object error) {
    if (error is fb.FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'missing-email':
          return 'Enter an email address to continue.';
        case 'missing-password':
          return 'Enter your password to continue.';
        case 'invalid-email-address':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
          return 'No account found for that email.';
        case 'wrong-password':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account with this email already exists.';
        case 'weak-password':
          return 'Choose a stronger password.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
        case 'network-request-failed':
          return 'Network error. Check your connection and try again.';
        case 'invalid-credential':
          return 'The login details are invalid or expired.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
