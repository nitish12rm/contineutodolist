import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contineutodolist/data/repositories/task_repository.dart';
import 'package:contineutodolist/viewmodels/auth/auth_bloc.dart';
import 'package:contineutodolist/viewmodels/auth/shared_pref_bloc.dart';
import 'package:contineutodolist/viewmodels/task/task_bloc.dart';
import 'package:contineutodolist/viewmodels/task/task_filter_bloc.dart';
import 'package:contineutodolist/views/auth/login_view.dart';
import 'package:contineutodolist/views/auth/signup_view.dart';
import 'package:contineutodolist/views/home/home_view.dart';
import 'package:contineutodolist/views/task/add_task_view.dart';
import 'package:contineutodolist/views/task/edit_task_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_bloc.dart';
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userid = prefs.getString('userid');
  String? name = prefs.getString('name');
  String? email = prefs.getString('email');
  bool? isLoggedin = prefs.getBool('isLoggedin');
  print(userid);
  // UserModel? user = await authRepository.autoLogin();
  runApp(MyApp(userid: userid,isLoggedin: isLoggedin, name: name,email: email,));
}

class MyApp extends StatelessWidget {
  final String? userid,name,email;
  final bool? isLoggedin;


  MyApp({this.userid, this.isLoggedin,  this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(create: (_) => TaskFilterBloc()),
        // Provide ThemeCubit
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
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
          return CupertinoApp(

            home: isLoggedin==true ? HomeScreen(userid: userid??"", name: name??"",email: email??"",) : LoginScreen(),
// home: HomeScreen(userid: userid??"", name: name??"",email: email??"",)
          );
        },
      ),
    );
  }
}