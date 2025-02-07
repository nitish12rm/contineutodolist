import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppThemes.lightTheme);

  void toggleTheme() {
    emit(state == AppThemes.lightTheme ? AppThemes.darkTheme : AppThemes.lightTheme);
  }
}
