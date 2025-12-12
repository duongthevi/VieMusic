import 'package:just_audio/just_audio.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';

class PocketBaseClient {
  late final PocketBase pb;

  PocketBaseClient(SharedPreferences prefs, {String baseUrl = 'http://54.66.165.43:8090'}) {

    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    pb = PocketBase(
      baseUrl,
      authStore: store,
    );
  }

  String getFileUrl({
    required String collectionId,
    required String recordId,
    required String filename,
  }) {
    try {
      if (filename.isEmpty) return '';

      final record = RecordModel.fromJson({
        'id': recordId,
        'collectionId': collectionId,
        'collectionName': collectionId,
      });

      return pb.files.getUrl(record, filename).toString();
    } catch (e) {
      print('Error getting file URL: $e');
      return '';
    }
  }
  /// check authentication
  bool get isAuthenticated => pb.authStore.isValid;

  /// logout
  Future<void> logout() async {
    await sl<AudioPlayer>().stop();
    pb.authStore.clear();
  }
}