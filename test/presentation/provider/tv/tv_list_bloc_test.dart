import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_popular_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_state.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvListBloc tvListBloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvListBloc = TvListBloc(
      getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

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
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Now Playing TvSeries', () {
    blocTest<TvListBloc, TvListState>(
      'initial state should be empty',
      build: () => tvListBloc,
      verify: (bloc) {
        expect(bloc.state.nowPlayingState, RequestState.Empty);
        expect(bloc.state.popularState, RequestState.Empty);
        expect(bloc.state.topRatedState, RequestState.Empty);
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should get data from the usecase',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        const TvListState(nowPlayingState: RequestState.Loading),
        TvListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingTvSeries: tTvSeriesList,
        ),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        const TvListState(nowPlayingState: RequestState.Loading),
        const TvListState(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Popular TvSeries', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvListState(popularState: RequestState.Loading),
        TvListState(
          popularState: RequestState.Loaded,
          popularTvSeries: tTvSeriesList,
        ),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvListState(popularState: RequestState.Loading),
        const TvListState(
          popularState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Top Rated TvSeries', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvListState(topRatedState: RequestState.Loading),
        TvListState(
          topRatedState: RequestState.Loaded,
          topRatedTvSeries: tTvSeriesList,
        ),
      ],
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvListState(topRatedState: RequestState.Loading),
        const TvListState(
          topRatedState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}
