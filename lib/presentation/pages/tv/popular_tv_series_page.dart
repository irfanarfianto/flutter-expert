import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_state.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  const PopularTvSeriesPage({super.key});

  @override
  _PopularTvSeriesPageState createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries()),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Popular TV Series'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
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
