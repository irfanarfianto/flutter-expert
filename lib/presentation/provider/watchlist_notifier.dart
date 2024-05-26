import 'package:flutter/material.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_watchlist_tv.dart';

class WatchlistNotifier extends ChangeNotifier {
  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  var _watchlist = <dynamic>[];
  List<dynamic> get watchlist => _watchlist;

  String _message = '';
  String get message => _message;

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistNotifier({
    required this.getWatchlistMovies,
    required this.getWatchlistTvSeries,
  });

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final movieResult = await getWatchlistMovies.execute();
    final tvResult = await getWatchlistTvSeries.execute();

    final List<dynamic> tempList = [];

    movieResult.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
      },
      (movieData) {
        tempList.addAll(movieData);
      },
    );

    tvResult.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
      },
      (tvData) {
        tempList.addAll(tvData);
      },
    );

    if (_watchlistState != RequestState.Error) {
      _watchlist = tempList;
      _watchlistState = RequestState.Loaded;
    }

    notifyListeners();
  }
}
