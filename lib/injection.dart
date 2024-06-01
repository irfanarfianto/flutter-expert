import 'package:http/http.dart' as http;
import 'package:submission_flutter_expert/data/datasources/db/database_helper.dart';
import 'package:submission_flutter_expert/data/datasources/movie_local_data_source.dart';
import 'package:submission_flutter_expert/data/datasources/movie_remote_data_source.dart';
import 'package:submission_flutter_expert/data/datasources/tv_local_data_source.dart';
import 'package:submission_flutter_expert/data/datasources/tv_remote_data_source.dart';
import 'package:submission_flutter_expert/data/repositories/movie_repository_impl.dart';
import 'package:submission_flutter_expert/data/repositories/tv_repository_impl.dart';
import 'package:submission_flutter_expert/domain/repositories/movie_repository.dart';
import 'package:submission_flutter_expert/domain/repositories/tv_repository.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_movie_detail.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_popular_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_popular_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_tv_detail.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/get_watchlist_status.dart';
import 'package:submission_flutter_expert/domain/usecases/remove_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/save_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/search_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/search_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_detail/movie_detail_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/airing_today_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/popular_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/top_rated_tv_series_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/tv_list_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/tv_search_notifier.dart';
import 'package:submission_flutter_expert/presentation/provider/tv/watchlist_tv_series_notifier.dart';

final locator = GetIt.instance;

void init() {
  // Provider - Movies
  // locator.registerFactory(
  //   () => MovieListNotifier(
  //     getNowPlayingMovies: locator(),
  //     getPopularMovies: locator(),
  //     getTopRatedMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => MovieDetailNotifier(
  //     getMovieDetail: locator(),
  //     getMovieRecommendations: locator(),
  //     getWatchListStatus: locator(),
  //     saveWatchlist: locator(),
  //     removeWatchlist: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => MovieSearchNotifier(
  //     searchMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => PopularMoviesNotifier(
  //     locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => TopRatedMoviesNotifier(
  //     getTopRatedMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => WatchlistMovieNotifier(
  //     getWatchlistMovies: locator(),
  //   ),
  // );

  // Provider - TV Series
  locator.registerFactory(
    () => TvListNotifier(
      getNowPlayingTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => AiringTodayTvSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesNotifier(
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchNotifier(
      searchTvSeries: locator(),
    ),
  );

  // locator.registerFactory(
  //   () => WatchlistNotifier(
  //     getWatchlistMovies: locator(),
  //     getWatchlistTvSeries: locator(),
  //   ),
  // );

  // Blocs
  // locator.registerFactory(() => AiringTodayTvSeriesBloc(locator()));
  // locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  // locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  // locator.registerFactory(() => TvDetailBloc(
  //   getTvDetail: locator(),
  //   getTvRecommendations: locator(),
  //   getWatchListStatus: locator(),
  //   saveWatchlist: locator(),
  //   removeWatchlist: locator(),
  // ));
  // locator.registerFactory(() => TvListBloc(
  //   getNowPlayingTvSeries: locator(),
  //   getPopularTvSeries: locator(),
  //   getTopRatedTvSeries: locator(),
  // ));
  // locator.registerFactory(() => TvSeriesSearchBloc(locator()));
  locator.registerFactory(() => WatchlistBloc(
    getWatchlistMovies: locator(),
    getWatchlistTvSeries: locator(),
  ));

  locator.registerFactory(() => MovieDetailBloc(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));

  locator.registerFactory(() => MovieListBloc(
        getNowPlayingMovies: locator(),
        getPopularMovies: locator(),
        getTopRatedMovies: locator(),
      ));

  locator.registerFactory(() => MovieSearchBloc(
        searchMovies: locator(),
      ));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(
        getTopRatedMovies: locator(),
      ));

  // Use Case - Movies
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // Use Case - TV Series
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));

  // Repository - Movies
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Repository - TV Series
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Data Sources - Movies
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // Data Sources - TV Series
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // Helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // External
  locator.registerLazySingleton(() => http.Client());
}
