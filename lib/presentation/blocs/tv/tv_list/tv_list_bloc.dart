import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_popular_tv.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(const TvListState()) {
    on<FetchNowPlayingTvSeries>((event, emit) async {
      emit(state.copyWith(nowPlayingState: RequestState.Loading));

      final result = await getNowPlayingTvSeries.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            nowPlayingState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvSeriesData) {
          emit(state.copyWith(
            nowPlayingState: RequestState.Loaded,
            nowPlayingTvSeries: tvSeriesData,
          ));
        },
      );
    });

    on<FetchPopularTvSeries>((event, emit) async {
      emit(state.copyWith(popularState: RequestState.Loading));

      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            popularState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvSeriesData) {
          emit(state.copyWith(
            popularState: RequestState.Loaded,
            popularTvSeries: tvSeriesData,
          ));
        },
      );
    });

    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(state.copyWith(topRatedState: RequestState.Loading));

      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) {
          emit(state.copyWith(
            topRatedState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvSeriesData) {
          emit(state.copyWith(
            topRatedState: RequestState.Loaded,
            topRatedTvSeries: tvSeriesData,
          ));
        },
      );
    });
  }
}
