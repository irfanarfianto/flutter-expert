import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/airing_today_tv_series/airing_today_tv_series_state.dart';

class AiringTodayTvSeriesBloc
    extends Bloc<AiringTodayTvSeriesEvent, AiringTodayTvSeriesState> {
  final GetNowPlayingTvSeries getAiringTodayTvSeries;

  AiringTodayTvSeriesBloc(this.getAiringTodayTvSeries)
      : super(const AiringTodayTvSeriesState());

  Stream<AiringTodayTvSeriesState> mapEventToState(
      AiringTodayTvSeriesEvent event) async* {
    if (event is FetchAiringTodayTvSeries) {
      yield state.copyWith(state: RequestState.Loading);

      final result = await getAiringTodayTvSeries.execute();
      yield* result.fold(
        (failure) async* {
          yield state.copyWith(
              state: RequestState.Error, message: failure.message);
        },
        (tvSeriesData) async* {
          yield state.copyWith(
              state: RequestState.Loaded, tvSeries: tvSeriesData);
        },
      );
    }
  }
}
