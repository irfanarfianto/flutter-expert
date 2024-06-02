import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_state.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc bloc;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('initial state should be correct', () {
    // assert
    expect(bloc.state, const TopRatedMoviesState());
  });

  group('FetchTopRatedMovies', () {
    test(
        'should emit [Loading, Loaded] states when data is loaded successfully',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // assert later
      final expected = [
        const TopRatedMoviesState(state: RequestState.Loading),
        TopRatedMoviesState(
            state: RequestState.Loaded, movies: tMovieList),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchTopRatedMovies());
    });

    test('should emit [Loading, Error] states when data loading fails',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // assert later
      final expected = [
        const TopRatedMoviesState(state: RequestState.Loading),
        const TopRatedMoviesState(
            state: RequestState.Error, message: 'Server Failure'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchTopRatedMovies());
    });
  });
}
