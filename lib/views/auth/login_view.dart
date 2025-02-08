import 'package:contineutodolist/views/auth/signup_view.dart';
import 'package:contineutodolist/views/home/home_view.dart';
import 'package:contineutodolist/views/task/add_task_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/auth/auth_bloc.dart';
import '../../viewmodels/auth/auth_event.dart';
import '../../viewmodels/auth/auth_state.dart';
 // Import your SignupScreen

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Log In'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Email',
                padding: const EdgeInsets.all(16),
                keyboardType: TextInputType.emailAddress,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                padding: const EdgeInsets.all(16),
                obscureText: true,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    // Navigate to the home screen or next screen
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => HomeScreen( userid: state.user.id, name: state.user.name, email: state.user.email, ),
                      ),
                    );
                  } else if (state is AuthError) {
                    // Show error message
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Error'),
                        content: Text(state.message),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  return CupertinoButton.filled(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        context.read<AuthBloc>().add(
                          LoginEvent(email, password),
                        );
                      } else {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => const CupertinoAlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill all fields.'),
                            actions: [
                              CupertinoDialogAction(
                                child: Text('OK'),
                                onPressed: null,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Log In'),
                  );
                },
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                onPressed: () {
                  // Navigate to the signup screen
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => SignupScreen(),
                    ),
                  );
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

