import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_popular_movies.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_top_rated_movies.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchNowPlayingMovies>(_fetchNowPlayingMovies);
    on<FetchPopularMovies>(_fetchPopularMovies);
    on<FetchTopRatedMovies>(_fetchTopRatedMovies);
  }

  Future<void> _fetchNowPlayingMovies(
      FetchNowPlayingMovies event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading));
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
            nowPlayingState: RequestState.Error, message: failure.message));
      },
      (moviesData) {
        emit(state.copyWith(
            nowPlayingState: RequestState.Loaded,
            nowPlayingMovies: moviesData));
      },
    );
  }

  Future<void> _fetchPopularMovies(
      FetchPopularMovies event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(popularMoviesState: RequestState.Loading));
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
            popularMoviesState: RequestState.Error, message: failure.message));
      },
      (moviesData) {
        emit(state.copyWith(
            popularMoviesState: RequestState.Loaded,
            popularMovies: moviesData));
      },
    );
  }

  Future<void> _fetchTopRatedMovies(
      FetchTopRatedMovies event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(topRatedMoviesState: RequestState.Loading));
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
            topRatedMoviesState: RequestState.Error, message: failure.message));
      },
      (moviesData) {
        emit(state.copyWith(
            topRatedMoviesState: RequestState.Loaded,
            topRatedMovies: moviesData));
      },
    );
  }
}
