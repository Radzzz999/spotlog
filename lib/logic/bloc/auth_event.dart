import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  RegisterRequested(this.name, this.email, this.password, this.role);
}

class LogoutRequested extends AuthEvent {
  final String token;

  LogoutRequested(this.token);
}
