import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/popular_tv_series_page.dart';

import '../../../dummy_data/dummy_objects_tv.dart';
import 'popular_tv_page_test.mocks.dart';

@GenerateMocks([PopularTvSeriesBloc])
void main() {
  late MockPopularTvSeriesBloc mockBlocPopularTvSeriesBloc;

  setUp(() {
    mockBlocPopularTvSeriesBloc = MockPopularTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockBlocPopularTvSeriesBloc,
      child: MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBlocPopularTvSeriesBloc.state)
        .thenReturn(const PopularTvSeriesState(state: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final loadedState = PopularTvSeriesState(
      state: RequestState.Loaded,
      tvSeries: [testTvSeries],
    );

    when(mockBlocPopularTvSeriesBloc.state).thenReturn(loadedState);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const errorState = PopularTvSeriesState(
      state: RequestState.Error,
      message: 'Error message',
    );

    when(mockBlocPopularTvSeriesBloc.state).thenReturn(errorState);

    final textFinder = find.text('Error message');

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Pull to refresh should trigger refresh method',
      (WidgetTester tester) async {
    final loadedState = PopularTvSeriesState(
      state: RequestState.Loaded,
      tvSeries: [testTvSeries],
    );

    when(mockBlocPopularTvSeriesBloc.state).thenReturn(loadedState);

    final refreshIndicatorFinder = find.byType(RefreshIndicator);

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    // Check if the RefreshIndicator is present
    expect(refreshIndicatorFinder, findsOneWidget);

    // Perform a pull-to-refresh action
    await tester.drag(refreshIndicatorFinder, const Offset(0.0, -200.0));

    // Wait for the widget tree to rebuild
    await tester.pump();

    // Verify that the refresh method is called
    verify(mockBlocPopularTvSeriesBloc.add(FetchPopularTvSeries())).called(1);
  });
}
