import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_popular_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_state.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
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

  group('Now Playing Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'initial state should be empty',
      build: () => movieListBloc,
      verify: (bloc) {
        expect(bloc.state.nowPlayingState, RequestState.Empty);
        expect(bloc.state.popularMoviesState, RequestState.Empty);
        expect(bloc.state.topRatedMoviesState, RequestState.Empty);
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should get data from the usecase',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.Loading),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMoviesList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.Loading),
        const MovieListState(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Popular Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.Loading),
        MovieListState(
          popularMoviesState: RequestState.Loaded,
          popularMovies: tMoviesList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.Loading),
        const MovieListState(
          popularMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Top Rated Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.Loading),
        MovieListState(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: tMoviesList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.Loading),
        const MovieListState(
          topRatedMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}
