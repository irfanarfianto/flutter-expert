import 'package:equatable/equatable.dart';

abstract class AiringTodayTvSeriesEvent extends Equatable {
  const AiringTodayTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchAiringTodayTvSeries extends AiringTodayTvSeriesEvent {}
