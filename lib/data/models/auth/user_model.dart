import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:ct312h_project/domain/entities/auth/user_entity.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final List<String> linkedTracks;
  final List<String> followedArtists;
  final String created;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.linkedTracks,
    required this.followedArtists,
    required this.created,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',

      linkedTracks: List<String>.from(json['linked_tracks'] ?? []),
      followedArtists: List<String>.from(json['followed_artists'] ?? []),

      created: json['created'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity({required PocketBaseClient client}) {
    final String? fullName = name.isEmpty ? null : name;

    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      created: DateTime.tryParse(created) ?? DateTime.now(),

      imageURL: client.getFileUrl(
        collectionId: PbConstants.usersCollection,
        recordId: id,
        filename: avatar,
      ),

      linkedTracks: linkedTracks,
      followedArtists: followedArtists,
    );
  }
}