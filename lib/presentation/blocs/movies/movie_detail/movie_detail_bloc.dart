import 'package:bloc/bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/get_watchlist_status.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_movie_detail.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:submission_flutter_expert/domain/usecases/remove_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/save_watchlist.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieState: RequestState.Loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            movieState: RequestState.Error,
            message: failure.message,
          ));
        },
        (movie) {
          emit(state.copyWith(
            movie: movie,
            movieState: RequestState.Loaded,
          ));

          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                recommendationState: RequestState.Error,
                message: failure.message,
              ));
            },
            (movies) {
              emit(state.copyWith(
                movieRecommendations: movies,
                recommendationState: RequestState.Loaded,
              ));
            },
          );
        },
      );
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: watchlistAddSuccessMessage));
        },
      );

      add(LoadWatchlistStatus(event.movie.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: watchlistRemoveSuccessMessage));
        },
      );

      add(LoadWatchlistStatus(event.movie.id));
    });
  }
}
