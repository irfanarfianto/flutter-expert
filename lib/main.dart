import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/constants.dart';
import 'package:submission_flutter_expert/common/utils.dart';
import 'package:submission_flutter_expert/firebase_options.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_bloc.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_expert/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<AiringTodayTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
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
