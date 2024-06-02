import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/tv_series_detail_page.dart';

import '../../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailBloc])
void main() {
  late MockTvDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when TvSeries not added to watchlist',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

      when(mockBloc.state).thenReturn(
        const TvDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when TvSeries is added to watchlist',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(
        const TvDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: true,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(
        const TvDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      // Stub the stream method of the mock bloc
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(
        const TvDetailState(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
