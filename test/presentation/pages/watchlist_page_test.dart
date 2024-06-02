import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_state.dart';
import 'package:submission_flutter_expert/presentation/pages/watchlist_page.dart';
import 'package:submission_flutter_expert/presentation/widgets/movie_card_list.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks([WatchlistBloc])
void main() {
  late MockWatchlistBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistBloc();

    when(mockBloc.stream)
        .thenAnswer((_) => const Stream<WatchlistState>.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Watchlist page loading state', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const WatchlistState(
      watchlistState: RequestState.Loading,
    ));

    await tester.pumpWidget(makeTestableWidget(
      const WatchlistPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Watchlist page loaded state', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(WatchlistState(
      watchlistState: RequestState.Loaded,
      watchlist: [testMovie, testTvSeries],
    ));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('Watchlist page error state', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const WatchlistState(
      watchlistState: RequestState.Error,
      message: 'Failed to load watchlist',
    ));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to load watchlist'), findsOneWidget);
  });
}
