import 'package:equatable/equatable.dart';

abstract class TvListEvent extends Equatable {
  const TvListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvSeries extends TvListEvent {}

class FetchPopularTvSeries extends TvListEvent {}

class FetchTopRatedTvSeries extends TvListEvent {}
