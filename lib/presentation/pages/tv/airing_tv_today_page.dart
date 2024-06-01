import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/airing_today_tv_series_notifier.dart';
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
    Future.microtask(() {
      Provider.of<AiringTodayTvSeriesNotifier>(context, listen: false)
          .fetchAiringTodayTvSeries();
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    await Provider.of<AiringTodayTvSeriesNotifier>(context, listen: false)
        .fetchAiringTodayTvSeries();
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
          child: Consumer<AiringTodayTvSeriesNotifier>(
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
