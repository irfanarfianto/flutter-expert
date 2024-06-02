import 'package:bloc_test/bloc_test.dart';
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

  tearDown(() {
    bloc.close();
  });

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUsecase();
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvSeriesState: RequestState.Loading),
        const TvDetailState(
            tvSeriesState: RequestState.Loaded, tvSeriesDetail: testTvDetail),
        TvDetailState(
            tvSeriesState: RequestState.Loaded,
            tvSeriesDetail: testTvDetail,
            recommendationState: RequestState.Loaded,
            tvSeriesRecommendations: tTv),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTv));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvSeriesState: RequestState.Loading),
        const TvDetailState(
            tvSeriesState: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });

  group('Get Recommendations', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUsecase();
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvSeriesState: RequestState.Loading),
        const TvDetailState(
            tvSeriesState: RequestState.Loaded, tvSeriesDetail: testTvDetail),
        TvDetailState(
            tvSeriesState: RequestState.Loaded,
            tvSeriesDetail: testTvDetail,
            recommendationState: RequestState.Loaded,
            tvSeriesRecommendations: tTv),
      ],
    );
  });
  group('Watchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit correct states when adding to watchlist is successful',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => const Right('Ditambahkan ke Daftar Tonton'));
        when(mockGetWatchListStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testTvDetail)),
      expect: () => [
        const TvDetailState(watchlistMessage: 'Ditambahkan ke Daftar Tonton'),
        const TvDetailState(
            watchlistMessage: 'Ditambahkan ke Daftar Tonton',
            isAddedToWatchlist: true),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit correct states when adding to watchlist fails',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testTvDetail)),
      expect: () => [
        const TvDetailState(watchlistMessage: 'Failed'),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit correct states when loading watchlist status is successful',
      build: () {
        when(mockGetWatchListStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(testTvDetail.id)),
      expect: () => [
        const TvDetailState(isAddedToWatchlist: true),
      ],
    );
  });
}
