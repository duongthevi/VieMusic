import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../domain/usecases/playlist/update_playlist_req.dart';
import '../bloc/my_playlists_cubit.dart';

class EditPlaylistDialog extends StatefulWidget {
  final PlaylistEntity playlist;
  const EditPlaylistDialog({super.key, required this.playlist});

  @override
  State<EditPlaylistDialog> createState() => _EditPlaylistDialogState();
}

class _EditPlaylistDialogState extends State<EditPlaylistDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  File? _coverFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name);
    _descController = TextEditingController(text: widget.playlist.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _coverFile = File(image.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Playlist'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(12),
                    image: _buildCoverImage(),
                  ),
                  child: _coverFile == null && widget.playlist.coverUrl.isEmpty
                      ? const Icon(Icons.queue_music_rounded, color: Colors.white, size: 50)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Change Cover'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Playlist Name",
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final name = _nameController.text.trim();
            final description = _descController.text.trim();

            if (name.isNotEmpty) {
              final req = UpdatePlaylistReq(
                id: widget.playlist.id,
                name: name,
                description: description,
                cover: _coverFile,
              );

              await context.read<MyPlaylistsCubit>().updatePlaylist(req);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  DecorationImage? _buildCoverImage() {
    if (_coverFile != null) {
      return DecorationImage(
        image: FileImage(_coverFile!),
        fit: BoxFit.cover,
      );
    }
    if (widget.playlist.coverUrl.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(widget.playlist.coverUrl),
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
