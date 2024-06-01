import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/tv_detail.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
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

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
