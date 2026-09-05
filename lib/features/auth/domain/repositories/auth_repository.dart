import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authStateChanges();
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> registerWithEmail(
    String email,
    String password, {
    String? displayName,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<UserEntity?> signInWithGoogle();
  Future<void> updateDisplayName(String displayName);
  Future<void> updatePhotoUrl(String photoUrl);
  Future<void> signOut();
}
