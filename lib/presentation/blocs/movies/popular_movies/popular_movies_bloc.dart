// popular_movies_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/get_popular_movies.dart';
import 'popular_movies_event.dart';
import 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(const PopularMoviesState()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getPopularMovies.execute();

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
