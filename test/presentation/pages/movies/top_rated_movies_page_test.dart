import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_state.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/top_rated_movies_page.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockBlocTopRatedMoviesBloc;

  setUp(() {
    mockBlocTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBlocTopRatedMoviesBloc,
      child: MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBlocTopRatedMoviesBloc.state)
        .thenReturn(const TopRatedMoviesState(state: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final loadedState = TopRatedMoviesState(
      state: RequestState.Loaded,
      movies: [testMovie],
    );

    when(mockBlocTopRatedMoviesBloc.state).thenReturn(loadedState);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const errorState = TopRatedMoviesState(
      state: RequestState.Error,
      message: 'Error message',
    );

    when(mockBlocTopRatedMoviesBloc.state).thenReturn(errorState);

    final textFinder = find.text('Error message');

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Pull to refresh should trigger refresh method',
      (WidgetTester tester) async {
    final loadedState = TopRatedMoviesState(
      state: RequestState.Loaded,
      movies: [testMovie],
    );

    when(mockBlocTopRatedMoviesBloc.state).thenReturn(loadedState);

    final refreshIndicatorFinder = find.byType(RefreshIndicator);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    // Check if the RefreshIndicator is present
    expect(refreshIndicatorFinder, findsOneWidget);

    // Perform a pull-to-refresh action
    await tester.drag(refreshIndicatorFinder, const Offset(0.0, -200.0));

    // Wait for the widget tree to rebuild
    await tester.pump();

    // Verify that the refresh method is called
    verify(mockBlocTopRatedMoviesBloc.add(FetchTopRatedMovies())).called(1);
  });
}
