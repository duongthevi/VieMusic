import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/pocketbase_client.dart';
import '../../../service_locator.dart';
import '../bloc/change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Change Password')),
        body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              sl<PocketBaseClient>().logout();
              if (context.mounted) {
                context.go('/signup-or-signin');
              }
              context.pop();
            } else if (state is ChangePasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _oldPassController,
                    decoration: const InputDecoration(labelText: 'Old Password'),
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? 'Enter old password' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPassController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (v) =>
                    (v!.length < 8) ? 'Minimum 8 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPassController,
                    decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                    validator: (v) =>
                    v != _newPassController.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      if (state is ChangePasswordLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ChangePasswordCubit>().changePassword(
                              oldPassword: _oldPassController.text,
                              newPassword: _newPassController.text,
                            );
                          }
                        },
                        child: const Text('Save Password'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
