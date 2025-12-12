import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/song/song_entity.dart';
import '../../repository/song/song_repository.dart';

class GetNewsSongsUseCase implements UseCase<Either<String, List<SongEntity>>, void> {

  final SongsRepository _repository;

  GetNewsSongsUseCase(this._repository);

  @override
  Future<Either<String, List<SongEntity>>> call({void params}) async{
    return await _repository.getNewsSongs();
  }
}