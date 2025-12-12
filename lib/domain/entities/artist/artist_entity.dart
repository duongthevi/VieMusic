class ArtistEntity {
  final String id;
  final String name;
  final String coverUrl;
  final String bio;
  final DateTime created;

  ArtistEntity({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.bio,
    required this.created,
  });
}