import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/popular_tv_series_page.dart';

import 'popular_tv_page_test.mocks.dart';

@GenerateMocks([PopularTvSeriesBloc])
void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvSeriesBloc();
    // Stub the stream method
    when(mockBloc.stream)
        .thenAnswer((_) => const Stream<PopularTvSeriesState>.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('PopularTvSeriesPage displays loading indicator when loading',
      (WidgetTester tester) async {
    when(mockBloc.state)
        .thenReturn(const PopularTvSeriesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(
      const PopularTvSeriesPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'PopularTvSeriesPage displays error message when error state is received',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const PopularTvSeriesState(
        state: RequestState.Error, message: 'Error message'));

    await tester.pumpWidget(makeTestableWidget(
      const PopularTvSeriesPage(),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
