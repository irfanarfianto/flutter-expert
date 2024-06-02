import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/top_rated_tv_series/top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this.getTopRatedTvSeries)
      : super(const TopRatedTvSeriesState()) {
    on<FetchTopRatedTvSeries>(_onFetchTopRatedTvSeries);
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeries event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(
          state.copyWith(state: RequestState.Error, message: failure.message)),
      (tvSeriesData) => emit(
          state.copyWith(state: RequestState.Loaded, tvSeries: tvSeriesData)),
    );
  }
}
