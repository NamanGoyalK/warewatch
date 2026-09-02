import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
      (u) => u == null ? null : UserModel.fromFirebase(u),
    );
  }

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) async {
    final creds = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = creds.user;
    return user == null ? null : UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity?> registerWithEmail(String email, String password) async {
    final creds = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = creds.user;
    return user == null ? null : UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    // 1. authenticate() replaces signIn() in v7+
    final GoogleSignInAccount account = await _googleSignIn.authenticate();

    // 2. account.authentication is now a synchronous getter
    final GoogleSignInAuthentication auth = account.authentication;

    // 3. Firebase only requires idToken to verify identity
    final credential = fb.GoogleAuthProvider.credential(idToken: auth.idToken);

    final result = await _firebaseAuth.signInWithCredential(credential);
    final user = result.user;
    return user == null ? null : UserModel.fromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }
}
