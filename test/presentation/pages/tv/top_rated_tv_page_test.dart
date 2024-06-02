import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/top_rated_tv_series_page.dart';

import '../../../dummy_data/dummy_objects_tv.dart';
import 'top_rated_tv_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesBloc])
void main() {
  late MockTopRatedTvSeriesBloc mockBlocTopRatedTvSeriesBloc;

  setUp(() {
    mockBlocTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBlocTopRatedTvSeriesBloc,
      child: MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBlocTopRatedTvSeriesBloc.state)
        .thenReturn(const TopRatedTvSeriesState(state: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final loadedState = TopRatedTvSeriesState(
      state: RequestState.Loaded,
      tvSeries: [testTvSeries],
    );

    when(mockBlocTopRatedTvSeriesBloc.state).thenReturn(loadedState);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const errorState = TopRatedTvSeriesState(
      state: RequestState.Error,
      message: 'Error message',
    );

    when(mockBlocTopRatedTvSeriesBloc.state).thenReturn(errorState);

    final textFinder = find.text('Error message');

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Pull to refresh should trigger refresh method',
      (WidgetTester tester) async {
    final loadedState = TopRatedTvSeriesState(
      state: RequestState.Loaded,
      tvSeries: [testTvSeries],
    );

    when(mockBlocTopRatedTvSeriesBloc.state).thenReturn(loadedState);

    final refreshIndicatorFinder = find.byType(RefreshIndicator);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    // Check if the RefreshIndicator is present
    expect(refreshIndicatorFinder, findsOneWidget);

    // Perform a pull-to-refresh action
    await tester.drag(refreshIndicatorFinder, const Offset(0.0, -200.0));

    // Wait for the widget tree to rebuild
    await tester.pump();

    // Verify that the refresh method is called
    verify(mockBlocTopRatedTvSeriesBloc.add(FetchTopRatedTvSeries())).called(1);
  });
}
