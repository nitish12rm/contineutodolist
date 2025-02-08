import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class SharedPrefsEvent {}

class LoadPreferences extends SharedPrefsEvent {}

class SaveUserDetails extends SharedPrefsEvent {
  final String name;
  final String email;

  SaveUserDetails(this.name, this.email);
}

class ClearPreferences extends SharedPrefsEvent {}

// State
class SharedPrefsState {
  final String? userName;
  final String? userEmail;

  SharedPrefsState({this.userName, this.userEmail});
}

// Bloc
class SharedPrefsBloc extends Bloc<SharedPrefsEvent, SharedPrefsState> {
  SharedPrefsBloc() : super(SharedPrefsState()) {
    on<LoadPreferences>(_onLoadPreferences);
    on<SaveUserDetails>(_onSaveUserDetails);
    on<ClearPreferences>(_onClearPreferences);
  }

  Future<void> _onLoadPreferences(LoadPreferences event, Emitter<SharedPrefsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('name');
    final String? userEmail = prefs.getString('email');

    emit(SharedPrefsState(userName: userName, userEmail: userEmail));
  }

  Future<void> _onSaveUserDetails(SaveUserDetails event, Emitter<SharedPrefsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', event.name);
    await prefs.setString('user_email', event.email);

    emit(SharedPrefsState(userName: event.name, userEmail: event.email));
  }

  Future<void> _onClearPreferences(ClearPreferences event, Emitter<SharedPrefsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    emit(SharedPrefsState(userName: null, userEmail: null));
  }
}
