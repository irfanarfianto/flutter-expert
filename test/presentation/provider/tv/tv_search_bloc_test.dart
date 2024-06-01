import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/search_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_state.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc tvSeriesSearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSeriesSearchBloc = TvSeriesSearchBloc(mockSearchTvSeries);
  });

  final tTvSeriesModel = TvSeries(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    name: 'Spider-Man',
    firstAirDate: '2002-05-01',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  const tQuery = 'spiderman';

  group('TvSeriesSearchBloc', () {
    test('initial state should be TvSeriesSearchState with RequestState.Empty',
        () {
      expect(tvSeriesSearchBloc.state, const TvSeriesSearchState());
    });

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesSearchBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesSearch(tQuery)),
      expect: () => [
        const TvSeriesSearchState(state: RequestState.Loading),
        TvSeriesSearchState(
          state: RequestState.Loaded,
          searchResult: tTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvSeriesSearchBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesSearch(tQuery)),
      expect: () => [
        const TvSeriesSearchState(state: RequestState.Loading),
        const TvSeriesSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );
  });
}
