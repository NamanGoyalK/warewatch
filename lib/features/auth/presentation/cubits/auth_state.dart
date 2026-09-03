import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user.uid, user.email];
}

class AuthUnauthenticated extends AuthState {}

class AuthPasswordResetSent extends AuthState {
  final String email;

  AuthPasswordResetSent(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
