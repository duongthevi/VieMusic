import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:dartz/dartz.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class BasePocketBaseDataSource {
  final PocketBaseClient _client;
  BasePocketBaseDataSource(this._client);
  PocketBase get pb => _client.pb;

  PocketBaseClient get client => _client;

  Future<Either<String, T>> tryCatchWrapper<T>(
      Future<T> Function() future) async {
    try {
      final result = await future();
      return Right(result);
    } on ClientException catch (e) {
      return Left(_parseClientException(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  String _parseClientException(ClientException e) {
    final response = e.response;

    try {
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null && data.isNotEmpty) {
        final firstErrorField = data.values.first as Map<String, dynamic>?;
        final message = firstErrorField?['message'] as String?;
        if (message != null) {
          return message;
        }
      }
    } catch (_) {
    }
    final topLevelMessage = response['message'] as String?;
    if (topLevelMessage != null) {
      return topLevelMessage;
    }
    return e.toString();
  }
}