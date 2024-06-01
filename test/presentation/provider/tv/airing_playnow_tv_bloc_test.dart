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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));
    // act
    bloc.add(FetchAiringTodayTvSeries());
    // assert
    await expectLater(
      bloc.stream,
      emitsInOrder([
        emits(const AiringTodayTvSeriesState(state: RequestState.Loading)),
        emits(AiringTodayTvSeriesState(
            state: RequestState.Loaded, tvSeries: tTvSeriesList)),
      ]),
    );
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTvSeries.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    bloc.add(FetchAiringTodayTvSeries());
    // assert
    await expectLater(
      bloc.stream,
      emitsInOrder([
        emits(const AiringTodayTvSeriesState(state: RequestState.Loading)),
        emits(const AiringTodayTvSeriesState(
            state: RequestState.Error, message: 'Server Failure')),
      ]),
    );
  });
}
