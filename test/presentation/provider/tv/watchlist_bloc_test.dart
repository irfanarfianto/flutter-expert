import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_watchlist_tv.dart';

import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_state.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../dummy_data/dummy_objects_tv.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, GetWatchlistTvSeries])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistBloc = WatchlistBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  group('WatchlistBloc', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'emits [Loading, Loaded] when FetchWatchlist is successful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right([testWatchlistTvSeries]));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlist()),
      expect: () => [
        const WatchlistState(watchlistState: RequestState.Loading),
        WatchlistState(
          watchlistState: RequestState.Loaded,
          watchlist: [testWatchlistMovie, testWatchlistTvSeries],
        ),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'emits [Loading, Error] when FetchWatchlist fails',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer(
            (_) async => const Left(DatabaseFailure("Can't get data")));
        when(mockGetWatchlistTvSeries.execute()).thenAnswer(
            (_) async => const Left(DatabaseFailure("Can't get data")));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlist()),
      expect: () => [
        const WatchlistState(watchlistState: RequestState.Loading),
        const WatchlistState(
          watchlistState: RequestState.Error,
          message: "Can't get data",
        ),
      ],
    );
  });
}
