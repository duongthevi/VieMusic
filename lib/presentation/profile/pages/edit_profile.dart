import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/entities/auth/user_entity.dart';
import '../../../service_locator.dart';
import '../bloc/edit_profile_cubit.dart';
import '../bloc/edit_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity userEntity;

  const EditProfilePage({
    super.key,
    required this.userEntity,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  File? _newAvatarFile;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.userEntity.fullName ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }
  void _saveProfile(BuildContext contextCon) {
    if (_formKey.currentState!.validate()) {
      contextCon.read<EditProfileCubit>().updateProfile(
        newFullName: _fullNameController.text.trim(),
        newAvatarFile: _newAvatarFile,
      );
    }
  }

  void _selectAvatar(BuildContext contextCon) async {
    final file = await contextCon.read<EditProfileCubit>().pickNewAvatar();
    if (file != null) {
      setState(() {
        _newAvatarFile = file;
      });
    }
  }

  ImageProvider? _getAvatarImageProvider(String? currentAvatarUrl) {
    if (_newAvatarFile != null) {
      return FileImage(_newAvatarFile!);
    }
    if (currentAvatarUrl != null && currentAvatarUrl.isNotEmpty) {
      return NetworkImage(currentAvatarUrl);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditProfileCubit>(),
      child: Scaffold(
        appBar: const BasicAppbar(
          title: Text('Edit Profile'),
        ),
        body: Builder(
            builder: (contextCon) {
              return BlocListener<EditProfileCubit, EditProfileState>(
                listener: (context, state) {
                  if (state is EditProfileSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    context.pop();
                  } else if (state is EditProfileFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: _buildFormContent(contextCon),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext contextCon) {
    final String currentAvatarUrl = widget.userEntity.imageURL ?? '';
    final String currentEmail = widget.userEntity.email ?? '';
    final ImageProvider? avatarProvider = _getAvatarImageProvider(currentAvatarUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade600,
                backgroundImage: avatarProvider,
                child: (avatarProvider == null)
                    ? const Icon(Icons.person, size: 70, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => _selectAvatar(contextCon),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name cannot be empty.';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        TextFormField(
          initialValue: currentEmail,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email_outlined),
            suffixText: '(Cannot be edited)',
            suffixStyle: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 40),

        BlocBuilder<EditProfileCubit, EditProfileState>(
          builder: (context, editState) {
            return ElevatedButton(
              onPressed: (editState is EditProfileLoading)
                  ? null
                  : () => _saveProfile(contextCon),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: (editState is EditProfileLoading)
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}