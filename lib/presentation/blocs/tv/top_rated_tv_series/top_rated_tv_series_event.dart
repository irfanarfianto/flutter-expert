import 'package:equatable/equatable.dart';

abstract class TopRatedTvSeriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTopRatedTvSeries extends TopRatedTvSeriesEvent {}
