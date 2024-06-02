import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_popular_tv.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/popular_tv_series/popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc(this.getPopularTvSeries)
      : super(const PopularTvSeriesState()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await getPopularTvSeries.execute();

      result.fold((failure) {
        emit(state.copyWith(
            state: RequestState.Error, message: failure.message));
      }, (tvSeriesData) {
        emit(
            state.copyWith(state: RequestState.Loaded, tvSeries: tvSeriesData));
      });
    });
  }
}
