import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({super.key});

  @override
  _TopRatedTvSeriesPageState createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries()),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top Rated TV Series'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
            builder: (context, state) {
              if (state.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.state == RequestState.Loaded) {
                return RefreshIndicator(
                  onRefresh: _refresh,
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
