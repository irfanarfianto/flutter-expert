import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

class AiringTodayTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-tv-series';

  const AiringTodayTvSeriesPage({super.key});

  @override
  _AiringTodayTvSeriesPageState createState() =>
      _AiringTodayTvSeriesPageState();
}

class _AiringTodayTvSeriesPageState extends State<AiringTodayTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AiringTodayTvSeriesBloc>().add(FetchAiringTodayTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TV Airing Today'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
            builder: (context, state) {
              if (state.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.state == RequestState.Loaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<AiringTodayTvSeriesBloc>()
                        .add(FetchAiringTodayTvSeries());
                  },
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final tvSeries = state.tvSeries[index];
                        return TvSeriesCard(tvSeries);
                      },
                      itemCount: state.tvSeries.length,
                    ),
                  ),
                );
              } else {
                return Center(
                  key: const Key('error_message'),
                  child: Text(state.message),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
