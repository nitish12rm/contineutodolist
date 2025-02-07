abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent(this.name, this.email, this.password);
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvent {}
