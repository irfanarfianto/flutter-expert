import 'package:dartz/dartz.dart';

import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/domain/entities/movie_detail.dart';
import 'package:submission_flutter_expert/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
