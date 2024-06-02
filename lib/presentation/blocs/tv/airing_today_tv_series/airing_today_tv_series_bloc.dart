import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_now_playing_tv.dart';
import 'airing_today_tv_series_event.dart';
import 'airing_today_tv_series_state.dart';

class AiringTodayTvSeriesBloc
    extends Bloc<AiringTodayTvSeriesEvent, AiringTodayTvSeriesState> {
  final GetNowPlayingTvSeries getAiringTodayTvSeries;

  AiringTodayTvSeriesBloc(this.getAiringTodayTvSeries)
      : super(const AiringTodayTvSeriesState()) {
    on<FetchAiringTodayTvSeries>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getAiringTodayTvSeries.execute();

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              state: RequestState.Error,
              message: failure.message,
            ),
          );
        },
        (tvSeriesData) {
          emit(
            state.copyWith(
              state: RequestState.Loaded,
              tvSeries: tvSeriesData,
            ),
          );
        },
      );
    });
  }
}
