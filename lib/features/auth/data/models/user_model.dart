import '../../domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromFirebase(fb.User user) {
    String? photoUrl = user.photoURL;
    if (photoUrl == null || photoUrl.trim().isEmpty) {
      for (final profile in user.providerData) {
        if (profile.photoURL != null && profile.photoURL!.trim().isNotEmpty) {
          photoUrl = profile.photoURL;
          break;
        }
      }
    }

    String? displayName = user.displayName;
    if (displayName == null || displayName.trim().isEmpty) {
      for (final profile in user.providerData) {
        if (profile.displayName != null &&
            profile.displayName!.trim().isNotEmpty) {
          displayName = profile.displayName;
          break;
        }
      }
    }

    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}
