import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/tv_detail.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int tvId;

  const FetchTvDetail(this.tvId);

  @override
  List<Object> get props => [tvId];
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int tvId;

  const LoadWatchlistStatus(this.tvId);

  @override
  List<Object> get props => [tvId];
}

class AddToWatchlist extends TvDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
