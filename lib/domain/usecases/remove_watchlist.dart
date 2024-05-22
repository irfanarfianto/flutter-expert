import 'package:dartz/dartz.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/domain/entities/movie_detail.dart';
import 'package:submission_flutter_expert/domain/repositories/movie_repository.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
