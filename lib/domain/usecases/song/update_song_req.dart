class UpdateSongReq {
  final String songId;
  final String? title;
  final String? albumId;
  final List<String>? artistIds;

  UpdateSongReq({
    required this.songId,
    this.title,
    this.albumId,
    this.artistIds,
  });

  Map<String, dynamic> toPocketBaseBody() {
    final body = <String, dynamic>{};
    if (title != null) {
      body['title'] = title;
    }
    if (albumId != null) {
      body['album'] = albumId;
    }
    if (artistIds != null) {
      body['artists'] = artistIds;
    }
    return body;
  }
}