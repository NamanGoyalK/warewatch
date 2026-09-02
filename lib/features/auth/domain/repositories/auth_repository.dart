import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authStateChanges();
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> registerWithEmail(String email, String password);
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
}
