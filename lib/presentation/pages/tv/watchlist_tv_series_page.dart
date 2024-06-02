// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:submission_flutter_expert/common/state_enum.dart';
// import 'package:submission_flutter_expert/common/utils.dart';
// import 'package:submission_flutter_expert/presentation/provider/tv/watchlist_tv_series_notifier.dart';
// import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

// class WatchlistTvSeriesPage extends StatefulWidget {
//   static const ROUTE_NAME = '/watchlist-tv-series';

//   const WatchlistTvSeriesPage({super.key});

//   @override
//   _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
// }

// class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
//     with RouteAware {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
//           .fetchWatchlistTvSeries();
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }

//   @override
//   void didPopNext() {
//     Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
//         .fetchWatchlistTvSeries();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//       behavior: const ScrollBehavior().copyWith(overscroll: false),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Watchlist TV Series'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Consumer<WatchlistTvSeriesNotifier>(
//             builder: (context, data, child) {
//               if (data.watchlistState == RequestState.Loading) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (data.watchlistState == RequestState.Loaded) {
//                 return ListView.builder(
//                   itemBuilder: (context, index) {
//                     final tvSeries = data.watchlistTvSeries[index];
//                     return TvSeriesCard(tvSeries);
//                   },
//                   itemCount: data.watchlistTvSeries.length,
//                 );
//               } else {
//                 return Center(
//                   key: const Key('error_message'),
//                   child: Text(data.message),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }
// }
