import 'package:dartz/dartz.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/repositories/movie_repository.dart';
import 'package:submission_flutter_expert/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
