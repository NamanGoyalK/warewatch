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
  Future<UserEntity?> registerWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    final creds = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = creds.user;
    if (user == null) {
      return null;
    }

    if (displayName != null && displayName.trim().isNotEmpty) {
      await user.updateDisplayName(displayName.trim());
      await user.reload();
    }

    final currentUser = _firebaseAuth.currentUser;
    return currentUser == null
        ? UserModel.fromFirebase(user)
        : UserModel.fromFirebase(currentUser);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication auth = account.authentication;
    final credential = fb.GoogleAuthProvider.credential(idToken: auth.idToken);
    final result = await _firebaseAuth.signInWithCredential(credential);
    final user = result.user;
    if (user != null) {
      if ((user.photoURL == null || user.photoURL!.isEmpty) && account.photoUrl != null) {
        await user.updatePhotoURL(account.photoUrl);
      }
      if ((user.displayName == null || user.displayName!.isEmpty) && account.displayName != null) {
        await user.updateDisplayName(account.displayName);
      }
      await user.reload();
    }
    final refreshedUser = _firebaseAuth.currentUser ?? user;
    return refreshedUser == null ? null : UserModel.fromFirebase(refreshedUser);
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }
  }

  @override
  Future<void> updatePhotoUrl(String photoUrl) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoUrl.trim());
      await user.reload();
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }
}
