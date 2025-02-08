import 'package:contineutodolist/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: false)) {
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(isDarkMode: !state.isDarkMode));
    });
  }
}
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}
class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});

  ThemeData get themeData {
    return isDarkMode ? _darkTheme : _lightTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ThemeColors.lightPrimaryColor,
    scaffoldBackgroundColor: ThemeColors.lightBackgroundColor,
    cardColor: ThemeColors.lightCardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: ThemeColors.lightTextColor),
      bodyMedium: TextStyle(color: ThemeColors.lightTextColor),
    ),
    iconTheme: IconThemeData(color: ThemeColors.lightIconColor),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ThemeColors.darkPrimaryColor,
    scaffoldBackgroundColor: ThemeColors.darkBackgroundColor,
    cardColor: ThemeColors.darkCardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: ThemeColors.darkTextColor),
      bodyMedium: TextStyle(color: ThemeColors.darkTextColor),
    ),
    iconTheme: IconThemeData(color: ThemeColors.darkIconColor),
  );
}