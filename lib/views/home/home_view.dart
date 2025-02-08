import 'package:contineutodolist/views/task/edit_task_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';

class HomeScreen extends StatelessWidget {
  final String userid,name,email;
  const HomeScreen({super.key, required this.userid, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.inactiveGray,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Setting',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return  TaskViews(userId: userid);
          case 1:
            return  SettingsScreen(email: email, name: name, userid: userid,);

          default:
            return  TaskViews(userId: userid);
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: Center(child: Text('Home Screen', style: TextStyle(fontSize: 18))),
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Tasks'),
      ),
      child: Center(child: Text('Tasks Screen', style: TextStyle(fontSize: 18))),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: Center(child: Text('Profile Screen', style: TextStyle(fontSize: 18))),
    );
  }
}
