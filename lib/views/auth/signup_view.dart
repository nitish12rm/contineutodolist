import 'package:contineutodolist/views/home/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/auth/auth_bloc.dart';
import '../../viewmodels/auth/auth_event.dart';
import '../../viewmodels/auth/auth_state.dart';
import 'login_view.dart';


class SignupScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sign Up'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Full Name',
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
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
                    final userid=state.user.id;
                    final name=state.user.name;
                    final email=state.user.email;
                    // Navigate to the home screen or next screen
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) =>  HomeScreen(userid:userid, name: name, email: email, ),
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
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                        context.read<AuthBloc>().add(
                          SignUpEvent(name, email, password),
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
                    child: const Text('Sign Up'),
                  );
                },
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                onPressed: () {
                  // Navigate to the login screen
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text('Already have an account? Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

