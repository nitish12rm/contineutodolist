import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

enum ThemeEvent { toggle }

class ThemeState {
  final bool isDarkMode;
  ThemeState({required this.isDarkMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: _getSystemTheme())) {
    on<ThemeEvent>((event, emit) {
      if (event == ThemeEvent.toggle) {
        emit(ThemeState(isDarkMode: !state.isDarkMode));
      }
    });
  }

  static bool _getSystemTheme() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}
