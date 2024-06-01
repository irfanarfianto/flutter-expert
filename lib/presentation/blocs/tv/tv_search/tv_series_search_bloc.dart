import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/search_tv.dart';
import 'tv_series_search_event.dart';
import 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc(this.searchTvSeries) : super(const TvSeriesSearchState()) {
    on<FetchTvSeriesSearch>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));

      final result = await searchTvSeries.execute(event.query);

      result.fold(
        (failure) {
          emit(state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ));
        },
        (data) {
          emit(state.copyWith(
            state: RequestState.Loaded,
            searchResult: data,
          ));
        },
      );
    });
  }
}
