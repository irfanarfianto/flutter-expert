import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_top_rated_movies.dart';
import 'top_rated_movies_event.dart';
import 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies)
      : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (moviesData) {
          emit(state.copyWith(
            state: RequestState.Loaded,
            movies: moviesData,
          ));
        },
      );
    });
  }
}
