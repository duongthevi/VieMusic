class UserEntity {
  final String? id;
  final String? fullName;
  final String? email;
  final String? imageURL;
  final List<String>? linkedTracks;
  final List<String>? followedArtists;
  final DateTime? created;

  UserEntity({
    this.id,
    this.fullName,
    this.email,
    this.imageURL,
    this.linkedTracks,
    this.followedArtists,
    this.created,
  });
}