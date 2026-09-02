import '../../domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel extends UserEntity {
  UserModel({required super.uid, super.email, super.displayName});

  factory UserModel.fromFirebase(fb.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}
