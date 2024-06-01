import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_state.dart';

import 'top_rated_tv_bloc_test.mocks.dart';


@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesBloc bloc;

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

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvSeriesBloc(mockGetTopRatedTvSeries);
  });

  test('initial state should be correct', () {
    // assert
    expect(bloc.state, const TopRatedTvSeriesState());
  });

  group('FetchTopRatedTvSeries', () {
    test(
        'should emit [Loading, Loaded] states when data is loaded successfully',
        () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // assert later
      final expected = [
         const TopRatedTvSeriesState(state: RequestState.Loading),
        TopRatedTvSeriesState(
            state: RequestState.Loaded, tvSeries: tTvSeriesList),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchTopRatedTvSeries());
    });

    test('should emit [Loading, Error] states when data loading fails',
        () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // assert later
      final expected = [
         const TopRatedTvSeriesState(state: RequestState.Loading),
        const TopRatedTvSeriesState(
            state: RequestState.Error, message: 'Server Failure'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchTopRatedTvSeries());
    });
  });
}
