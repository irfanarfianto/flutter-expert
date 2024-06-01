import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_watchlist_tv.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistBloc({
    required this.getWatchlistMovies,
    required this.getWatchlistTvSeries,
  }) : super(const WatchlistState()) {
    on<FetchWatchlist>((event, emit) async {
      emit(state.copyWith(watchlistState: RequestState.Loading));

      final movieResult = await getWatchlistMovies.execute();
      final tvResult = await getWatchlistTvSeries.execute();

      final List<dynamic> tempList = [];

      movieResult.fold(
        (failure) {
          emit(state.copyWith(
            watchlistState: RequestState.Error,
            message: failure.message,
          ));
        },
        (movieData) {
          tempList.addAll(movieData);
        },
      );

      tvResult.fold(
        (failure) {
          emit(state.copyWith(
            watchlistState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvData) {
          tempList.addAll(tvData);
        },
      );

      if (state.watchlistState != RequestState.Error) {
        emit(state.copyWith(
          watchlist: tempList,
          watchlistState: RequestState.Loaded,
        ));
      }
    });
  }
}
