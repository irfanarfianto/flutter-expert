import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/airing_tv_today_page.dart';

import 'airing_tv_series_test.mocks.dart';

@GenerateMocks([AiringTodayTvSeriesBloc])
void main() {
  late MockAiringTodayTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockAiringTodayTvSeriesBloc();
    // Stub the stream method
    when(mockBloc.stream)
        .thenAnswer((_) => const Stream<AiringTodayTvSeriesState>.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<AiringTodayTvSeriesBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('AiringTodayTvSeriesPage displays loading indicator when loading',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(
        const AiringTodayTvSeriesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(
      const AiringTodayTvSeriesPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'AiringTodayTvSeriesPage displays error message when error state is received',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const AiringTodayTvSeriesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(
      const AiringTodayTvSeriesPage(),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
