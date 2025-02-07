import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        UserModel? user = await authRepository.signUp(event.name, event.email, event.password);
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(AuthError("Signup failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        UserModel? user = await authRepository.login(event.email, event.password);
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(AuthError("Login failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}
