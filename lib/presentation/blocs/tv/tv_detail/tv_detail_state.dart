import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/entities/tv_detail.dart';

class TvDetailState extends Equatable {
  final TvSeriesDetail? tvSeriesDetail;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState tvSeriesState;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailState({
    this.tvSeriesDetail,
    this.tvSeriesRecommendations = const [],
    this.tvSeriesState = RequestState.Empty,
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    TvSeriesDetail? tvSeriesDetail,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? tvSeriesState,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesDetail,
        tvSeriesRecommendations,
        tvSeriesState,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage
      ];
}
