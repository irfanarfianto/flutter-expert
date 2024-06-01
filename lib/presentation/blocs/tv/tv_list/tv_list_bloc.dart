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
    on<FetchNowPlayingTv>(_fetchNowPlayingTv);
    on<FetchPopularTv>(_fetchPopularTv);
    on<FetchTopRatedTv>(_fetchTopRatedTv);
  }

  Future<void> _fetchNowPlayingTv(
      FetchNowPlayingTv event, Emitter<TvListState> emit) async {
    emit(state.copyWith(onTheAirState: RequestState.Loading));
    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
            onTheAirState: RequestState.Error, message: failure.message));
      },
      (tvSeriesData) {
        emit(state.copyWith(
            onTheAirState: RequestState.Loaded,
            onTheAirTvSeries: tvSeriesData));
      },
    );
  }

  Future<void> _fetchPopularTv(
      FetchPopularTv event, Emitter<TvListState> emit) async {
    emit(state.copyWith(popularTvSeriesState: RequestState.Loading));
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
            popularTvSeriesState: RequestState.Error,
            message: failure.message));
      },
      (tvSeriesData) {
        emit(state.copyWith(
            popularTvSeriesState: RequestState.Loaded,
            popularTvSeries: tvSeriesData));
      },
    );
  }

  Future<void> _fetchTopRatedTv(
      FetchTopRatedTv event, Emitter<TvListState> emit) async {
    emit(state.copyWith(topRatedTvSeriesState: RequestState.Loading));
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
            topRatedTvSeriesState: RequestState.Error,
            message: failure.message));
      },
      (tvSeriesData) {
        emit(state.copyWith(
            topRatedTvSeriesState: RequestState.Loaded,
            topRatedTvSeries: tvSeriesData));
      },
    );
  }
}
