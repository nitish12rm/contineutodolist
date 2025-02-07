import 'package:contineutodolist/data/repositories/task_repository.dart';
import 'package:contineutodolist/viewmodels/auth/auth_bloc.dart';
import 'package:contineutodolist/viewmodels/task/task_bloc.dart';
import 'package:contineutodolist/views/auth/login_view.dart';
import 'package:contineutodolist/views/auth/signup_view.dart';
import 'package:contineutodolist/views/task/add_task_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/theme/theme_cubit.dart';
import 'data/models/task_model.dart';
import 'data/models/user_model.dart';
import 'data/repositories/auth_repository.dart'; // Import AuthRepository

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter()); // Register Task Model

  await Hive.openBox<Task>('tasks'); // Open Hive Box for tasks
  AuthRepository authRepository = AuthRepository();
  UserModel? user = await authRepository.autoLogin();
  runApp(MyApp(user: user,));
}

class MyApp extends StatelessWidget {
  final UserModel? user;

  MyApp({this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide ThemeCubit
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        // Provide AuthBloc
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(
          create: (context) => TaskBloc(taskRepository: TaskRepository()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            theme: theme,
            home: user != null ? TaskScreen(userId: user!.id) : LoginScreen(),
          );
        },
      ),
    );
  }
}