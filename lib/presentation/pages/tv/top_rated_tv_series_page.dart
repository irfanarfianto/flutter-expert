import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/top_rated_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  _TopRatedTvSeriesPageState createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TopRatedTvSeriesNotifier>(context, listen: false)
          .fetchTopRatedTvSeries();
    });
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
          child: Consumer<TopRatedTvSeriesNotifier>(
            builder: (context, data, child) {
              if (data.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.state == RequestState.Loaded) {
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final tvSeries = data.tvSeries[index];
                      return TvSeriesCard(tvSeries);
                    },
                    itemCount: data.tvSeries.length,
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
