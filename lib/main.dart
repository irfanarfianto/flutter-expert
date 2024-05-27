import 'package:submission_flutter_expert/common/constants.dart';
import 'package:submission_flutter_expert/common/utils.dart';
import 'package:submission_flutter_expert/presentation/pages/about_page.dart';
import 'package:submission_flutter_expert/presentation/pages/home_page.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/movie_detail_page.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/popular_movies_page.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:submission_flutter_expert/presentation/pages/search_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/airing_tv_today_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:submission_flutter_expert/presentation/pages/watchlist_page.dart';
import 'package:submission_flutter_expert/presentation/provider/movies/movie_detail_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/movies/movie_list_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/movies/movie_search_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/movies/popular_movies_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/movies/top_rated_movies_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/movies/watchlist_movie_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/airing_today_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/tv_list_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/watchlist_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/popular_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/top_rated_tv_series_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_expert/injection.dart' as di;
import 'package:submission_flutter_expert/presentation/provider/watchlist_notifier.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<AiringTodayTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistNotifier>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomeMovieTvPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMovieTvPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case AiringTodayTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const AiringTodayTvSeriesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedTvSeriesPage());
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistTvSeriesPage());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
