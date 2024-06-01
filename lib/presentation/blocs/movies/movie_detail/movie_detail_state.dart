import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/entities/movie_detail.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movie;
  final List<Movie> movieRecommendations;
  final RequestState movieState;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.movie,
    this.movieRecommendations = const [],
    this.movieState = RequestState.Empty,
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    RequestState? movieState,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieState: movieState ?? this.movieState,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movie,
        movieRecommendations,
        movieState,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}
