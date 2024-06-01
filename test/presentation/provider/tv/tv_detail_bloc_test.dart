import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/usecases/get_watchlist_status.dart';
import 'package:submission_flutter_expert/domain/usecases/remove_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/save_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_tv_detail.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_state.dart';

import '../../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvSeriesDetail,
      getTvRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatus: mockGetWatchListStatusTv,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTvSeries,
    );
  });

  const tId = 1;

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    name: 'name',
    originalLanguage: 'originalLanguage',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    firstAirDate: 'firstAirDate',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tTv = <TvSeries>[tTvSeries];

  void arrangeUsecase() {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => const Right(testTvDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTv));
  }

  group('FetchTvDetail', () {
    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      arrangeUsecase();
      // assert later
      final expected = [
        const TvDetailState(tvSeriesState: RequestState.Loading),
        const TvDetailState(
            tvSeriesState: RequestState.Loaded, tvSeries: testTvDetail),
        TvDetailState(
            tvSeriesState: RequestState.Loaded,
            tvSeries: testTvDetail,
            recommendationState: RequestState.Loaded,
            tvSeriesRecommendations: tTv),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchTvDetail(tId));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTv));
      // assert later
      final expected = [
        const TvDetailState(tvSeriesState: RequestState.Loading),
        const TvDetailState(
            tvSeriesState: RequestState.Error, message: 'Server Failure'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const FetchTvDetail(tId));
    });
  });

  group('Watchlist', () {
    test('should emit correct states when adding to watchlist is successful',
        () async {
      // arrange
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // assert later
      final expected = [
        const TvDetailState(watchlistMessage: 'Added to Watchlist'),
        const TvDetailState(
            watchlistMessage: 'Added to Watchlist', isAddedToWatchlist: true),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const AddToWatchlist(testTvDetail));
    });

    test('should emit correct states when adding to watchlist fails', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // assert later
      final expected = [
        const TvDetailState(watchlistMessage: 'Failed'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const AddToWatchlist(testTvDetail));
    });

    test(
        'should emit correct states when removing from watchlist is successful',
        () async {
      // arrange
      when(mockRemoveWatchlistTvSeries.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // assert later
      final expected = [
        const TvDetailState(watchlistMessage: 'Removed from Watchlist'),
        const TvDetailState(
            watchlistMessage: 'Removed from Watchlist',
            isAddedToWatchlist: false),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const RemoveFromWatchlist(testTvDetail));
    });

    test('should emit correct states when removing from watchlist fails',
        () async {
      // arrange
      when(mockRemoveWatchlistTvSeries.execute(testTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // assert later
      final expected = [
        const TvDetailState(watchlistMessage: 'Failed'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const RemoveFromWatchlist(testTvDetail));
    });

    test(
        'should emit correct states when loading watchlist status is successful',
        () async {
      // arrange
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // assert later
      final expected = [
        const TvDetailState(isAddedToWatchlist: true),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(LoadWatchlistStatus(testTvDetail.id));
    });
  });
}
