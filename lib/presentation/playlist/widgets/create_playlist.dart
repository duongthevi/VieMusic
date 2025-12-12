import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/my_playlists_cubit.dart';
import '../../../domain/usecases/playlist/create_playlist_req.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({super.key});

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  File? _pickedCoverImage;
  bool _isPublic = false;
  bool _isSaving = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedCoverImage = File(pickedFile.path);
      });
    }
  }

  void _createPlaylist() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist name cannot be empty.')),
        );
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final CreatePlaylistReq req = CreatePlaylistReq(
      name: name,
      ownerId: '',
      description: description,
      isPublic: _isPublic,
      cover: _pickedCoverImage,
    );

    await context.read<MyPlaylistsCubit>().createPlaylist(req);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    final inputBorderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade600
        : Colors.grey.shade400;

    return AlertDialog(
      title: const Text('Create New Playlist'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Playlist Name (*)",
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Public', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _isPublic,
                  onChanged: _isSaving ? null : (value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: _isSaving ? null : _pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: inputBorderColor),
                  image: _pickedCoverImage != null
                      ? DecorationImage(
                    image: FileImage(_pickedCoverImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _pickedCoverImage == null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      Text('Select Cover Image', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isSaving ? null : _createPlaylist,
          child: _isSaving
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Create'),
        ),
      ],
    );
  }
}