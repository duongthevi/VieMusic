import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../repository/song/song_repository.dart';

class GetFavoriteSongsUseCase implements UseCase<Either,dynamic> {
  final SongsRepository _repository;
  GetFavoriteSongsUseCase(this._repository);

  @override
  Future<Either> call({params}) async{
    return await _repository.getUserFavoriteSongs();
  }
}