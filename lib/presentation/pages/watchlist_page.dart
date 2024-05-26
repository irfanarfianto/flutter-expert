import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/common/utils.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/presentation/provider/watchlist_notifier.dart';
import 'package:submission_flutter_expert/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistPage({super.key});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistNotifier>(context, listen: false)
            .fetchWatchlist());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistNotifier>(context, listen: false).fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<WatchlistNotifier>(
            builder: (context, data, child) {
              if (data.watchlistState == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.watchlistState == RequestState.Loaded) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final item = data.watchlist[index];
                    if (item is Movie) {
                      return MovieCard(item);
                    } else if (item is TvSeries) {
                      return TvSeriesCard(item);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: data.watchlist.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
