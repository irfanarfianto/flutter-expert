import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_state.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/top_rated_movies_page.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
    // Stub the stream method
    when(mockBloc.stream)
        .thenAnswer((_) => const Stream<TopRatedMoviesState>.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('TopRatedMoviesPage displays loading indicator when loading',
      (WidgetTester tester) async {
    when(mockBloc.state)
        .thenReturn(const TopRatedMoviesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(
      const TopRatedMoviesPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'TopRatedMoviesPage displays error message when error state is received',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const TopRatedMoviesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(
      const TopRatedMoviesPage(),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
