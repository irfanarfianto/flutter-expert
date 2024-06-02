import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/top_rated_tv_series_page.dart';

import 'top_rated_tv_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesBloc])
void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();
    // Stub the stream method
    when(mockBloc.stream)
        .thenAnswer((_) => const Stream<TopRatedTvSeriesState>.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('TopRatedTvSeriesPage displays loading indicator when loading',
      (WidgetTester tester) async {
    when(mockBloc.state)
        .thenReturn(const TopRatedTvSeriesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(
      const TopRatedTvSeriesPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'TopRatedTvSeriesPage displays error message when error state is received',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const TopRatedTvSeriesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(
      const TopRatedTvSeriesPage(),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
