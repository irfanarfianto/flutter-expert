import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_movie_detail.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/domain/usecases/get_watchlist_status.dart';
import 'package:submission_flutter_expert/domain/usecases/remove_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/save_watchlist.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_state.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

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
  final tMovies = <Movie>[tMovie];

  void arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => const Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
  }

  tearDown(() {
    bloc.close();
  });

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUsecase();
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        const MovieDetailState(
            movieState: RequestState.Loaded, movie: testMovieDetail),
        MovieDetailState(
            movieState: RequestState.Loaded,
            movie: testMovieDetail,
            recommendationState: RequestState.Loaded,
            movieRecommendations: tMovies),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        const MovieDetailState(
            movieState: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });

  group('Get Recommendations', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUsecase();
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        const MovieDetailState(
            movieState: RequestState.Loaded, movie: testMovieDetail),
        MovieDetailState(
            movieState: RequestState.Loaded,
            movie: testMovieDetail,
            recommendationState: RequestState.Loaded,
            movieRecommendations: tMovies),
      ],
    );
  });
  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit correct states when adding to watchlist is successful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Added to Watchlist'),
        const MovieDetailState(
            watchlistMessage: 'Added to Watchlist', isAddedToWatchlist: true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit correct states when adding to watchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Failed'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit correct states when loading watchlist status is successful',
      build: () {
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        const MovieDetailState(isAddedToWatchlist: true),
      ],
    );
  });
}
