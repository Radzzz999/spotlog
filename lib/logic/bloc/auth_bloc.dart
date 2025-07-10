import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final loginData = await repository.login(event.email, event.password);
        final token = loginData['token'];
        final role = loginData['role'];
        emit(AuthSuccess(token!, role!));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.register(event.name, event.email, event.password, event.role);
        emit(AuthLoggedOut());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.logout(event.token);
        emit(AuthLoggedOut());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
