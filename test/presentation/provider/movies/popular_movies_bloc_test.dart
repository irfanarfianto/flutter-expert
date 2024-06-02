import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_popular_movies.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_state.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc bloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  final tMovies = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    title: 'title',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMoviesList = <Movie>[tMovies];

  group('Populer Tv Series Bloc', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Loaded] when FetchPopularMovies is successful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        PopularMoviesState(state: RequestState.Loaded, movies: tMoviesList),
      ],
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Error] when FetchPopularMovies is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        const PopularMoviesState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });
}
