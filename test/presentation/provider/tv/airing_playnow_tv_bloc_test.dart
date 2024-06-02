import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_state.dart';

import 'airing_playnow_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late AiringTodayTvSeriesBloc bloc;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    bloc = AiringTodayTvSeriesBloc(mockGetNowPlayingTvSeries);
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

  group('Airing Today TvSeries Bloc', () {
    blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
      'emits [Loading, Loaded] when FetchAiringTodayTvSeries is successful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
      expect: () => [
        const AiringTodayTvSeriesState(state: RequestState.Loading),
        AiringTodayTvSeriesState(
          state: RequestState.Loaded,
          tvSeries: tTvSeriesList,
        ),
      ],
    );

    blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
      'emits [Loading, Error] when FetchAiringTodayTvSeries is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
      expect: () => [
        const AiringTodayTvSeriesState(state: RequestState.Loading),
        const AiringTodayTvSeriesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );
  });
}
