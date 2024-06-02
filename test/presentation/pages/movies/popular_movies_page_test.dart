import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_state.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/popular_movies_page.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
    // Stub the stream method
    when(mockBloc.stream)
        .thenAnswer((_) => const Stream<PopularMoviesState>.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('PopularMoviesPage displays loading indicator when loading',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.state)
        .thenReturn(const PopularMoviesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(
      const PopularMoviesPage(),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'emits [PopularMoviesLoaded] when FetchPopularMovies event is added',
      (WidgetTester tester) async {
    when(mockBloc.state)
        .thenReturn(const PopularMoviesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(
      const PopularMoviesPage(),
    ));

    when(mockBloc.state).thenReturn(
        const PopularMoviesState(state: RequestState.Loaded, movies: []));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets(
      'PopularMoviesPage displays error message when error state is received',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const PopularMoviesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(
      const PopularMoviesPage(),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
