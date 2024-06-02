import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_popular_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_state.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesBloc bloc;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(mockGetPopularTvSeries);
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

  group('Populer Tv Series Bloc', () {
    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'emits [Loading, Loaded] when FetchPopularTvSeries is successful',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const PopularTvSeriesState(state: RequestState.Loading),
        PopularTvSeriesState(
            state: RequestState.Loaded, tvSeries: tTvSeriesList),
      ],
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'emits [Loading, Error] when FetchPopularTvSeries is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const PopularTvSeriesState(state: RequestState.Loading),
        const PopularTvSeriesState(
            state: RequestState.Error, message: 'Server Failure'),
      ],
    );
  });
}
