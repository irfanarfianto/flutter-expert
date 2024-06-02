import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_state.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/movie_detail_page.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

      when(mockBloc.state).thenReturn(
        const MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(
        const MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: true,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(
        const MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(
        const MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
