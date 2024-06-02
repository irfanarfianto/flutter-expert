import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/airing_tv_today_page.dart';

import '../../../dummy_data/dummy_objects_tv.dart';
import 'airing_tv_series_test.mocks.dart';

@GenerateMocks([AiringTodayTvSeriesBloc])
void main() {
  late MockAiringTodayTvSeriesBloc mockBlocAiringTodayTvSeriesBloc;

  setUp(() {
    mockBlocAiringTodayTvSeriesBloc = MockAiringTodayTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<AiringTodayTvSeriesBloc>.value(
      value: mockBlocAiringTodayTvSeriesBloc,
      child: MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBlocAiringTodayTvSeriesBloc.state)
        .thenReturn(const AiringTodayTvSeriesState(state: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester
        .pumpWidget(makeTestableWidget(const AiringTodayTvSeriesPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final loadedState = AiringTodayTvSeriesState(
      state: RequestState.Loaded,
      tvSeries: [testTvSeries],
    );

    when(mockBlocAiringTodayTvSeriesBloc.state).thenReturn(loadedState);

    final listViewFinder = find.byType(ListView);

    await tester
        .pumpWidget(makeTestableWidget(const AiringTodayTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const errorState = AiringTodayTvSeriesState(
      state: RequestState.Error,
      message: 'Error message',
    );

    when(mockBlocAiringTodayTvSeriesBloc.state).thenReturn(errorState);

    final textFinder = find.text('Error message');

    await tester
        .pumpWidget(makeTestableWidget(const AiringTodayTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Pull to refresh should trigger refresh method',
      (WidgetTester tester) async {
    final loadedState = AiringTodayTvSeriesState(
      state: RequestState.Loaded,
      tvSeries: [testTvSeries],
    );

    when(mockBlocAiringTodayTvSeriesBloc.state).thenReturn(loadedState);

    final refreshIndicatorFinder = find.byType(RefreshIndicator);

    await tester
        .pumpWidget(makeTestableWidget(const AiringTodayTvSeriesPage()));

    // Check if the RefreshIndicator is present
    expect(refreshIndicatorFinder, findsOneWidget);

    // Perform a pull-to-refresh action
    await tester.drag(refreshIndicatorFinder, const Offset(0.0, -200.0));

    // Wait for the widget tree to rebuild
    await tester.pump();

    // Verify that the refresh method is called
    verify(mockBlocAiringTodayTvSeriesBloc.add(FetchAiringTodayTvSeries()))
        .called(1);
  });
}
