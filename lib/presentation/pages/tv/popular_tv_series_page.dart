// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/popular_tv_series_notifier.dart';
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
    Future.microtask(() {
      Provider.of<PopularTvSeriesNotifier>(context, listen: false)
          .fetchPopularTvSeries();
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    await Provider.of<PopularTvSeriesNotifier>(context, listen: false)
        .fetchPopularTvSeries();
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
          child: Consumer<PopularTvSeriesNotifier>(
            builder: (context, data, child) {
              if (data.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.state == RequestState.Loaded) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final tvSeries = data.tvSeries[index];
                        return TvSeriesCard(tvSeries);
                      },
                      itemCount: data.tvSeries.length,
                    ),
                  ),
                );
              } else {
                return Center(
                  key: const Key('error_message'),
                  child: Text(data.message),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
