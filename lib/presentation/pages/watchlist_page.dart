import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/common/utils.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_state.dart';
import 'package:submission_flutter_expert/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
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
    Future.microtask(() {
      context.read<WatchlistBloc>().add(FetchWatchlist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistBloc>().add(FetchWatchlist());
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
          child: BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
              if (state.watchlistState == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.watchlistState == RequestState.Loaded) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final item = state.watchlist[index];
                    if (item is Movie) {
                      return MovieCard(item);
                    } else if (item is TvSeries) {
                      return TvSeriesCard(item);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: state.watchlist.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
