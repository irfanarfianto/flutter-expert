import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/usecases/get_watchlist_status.dart';
import 'package:submission_flutter_expert/domain/usecases/remove_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/save_watchlist.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_tv_detail.dart';
import 'package:submission_flutter_expert/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_detail/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Ditambahkan ke Daftar Tonton';
  static const watchlistRemoveSuccessMessage = 'Dihapus dari Daftar Tonton';

  final GetTvSeriesDetail getTvDetail;
  final GetTvSeriesRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvDetailState()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchTvDetail(
      FetchTvDetail event, Emitter<TvDetailState> emit) async {
    emit(state.copyWith(tvSeriesState: RequestState.Loading));

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
            tvSeriesState: RequestState.Error, message: failure.message));
      },
      (tvSeries) async {
        emit(state.copyWith(
            tvSeriesState: RequestState.Loading, tvSeries: tvSeries));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
                recommendationState: RequestState.Error,
                message: failure.message));
          },
          (tvSeriesRecommendations) {
            emit(state.copyWith(
              recommendationState: RequestState.Loaded,
              tvSeriesRecommendations: tvSeriesRecommendations,
            ));
          },
        );
        emit(state.copyWith(tvSeriesState: RequestState.Loaded));
      },
    );
  }

  Future<void> _onAddToWatchlist(
      AddToWatchlist event, Emitter<TvDetailState> emit) async {
    final result = await saveWatchlist.execute(event.tvSeries);

    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    await _loadWatchlistStatus(event.tvSeries.id, emit);
  }

  Future<void> _onRemoveFromWatchlist(
      RemoveFromWatchlist event, Emitter<TvDetailState> emit) async {
    final result = await removeWatchlist.execute(event.tvSeries);

    result.fold(
      (failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    await _loadWatchlistStatus(event.tvSeries.id, emit);
  }

  Future<void> _onLoadWatchlistStatus(
      LoadWatchlistStatus event, Emitter<TvDetailState> emit) async {
    await _loadWatchlistStatus(event.id, emit);
  }

  Future<void> _loadWatchlistStatus(int id, Emitter<TvDetailState> emit) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
