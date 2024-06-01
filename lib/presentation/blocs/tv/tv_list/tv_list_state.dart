import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';

class TvListState extends Equatable {
  final List<TvSeries> onTheAirTvSeries;
  final RequestState onTheAirState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularTvSeriesState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedTvSeriesState;
  final String message;

  const TvListState({
    this.onTheAirTvSeries = const [],
    this.onTheAirState = RequestState.Empty,
    this.popularTvSeries = const [],
    this.popularTvSeriesState = RequestState.Empty,
    this.topRatedTvSeries = const [],
    this.topRatedTvSeriesState = RequestState.Empty,
    this.message = '',
  });

  TvListState copyWith({
    List<TvSeries>? onTheAirTvSeries,
    RequestState? onTheAirState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularTvSeriesState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedTvSeriesState,
    String? message,
  }) {
    return TvListState(
      onTheAirTvSeries: onTheAirTvSeries ?? this.onTheAirTvSeries,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularTvSeriesState: popularTvSeriesState ?? this.popularTvSeriesState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedTvSeriesState:
          topRatedTvSeriesState ?? this.topRatedTvSeriesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        onTheAirTvSeries,
        onTheAirState,
        popularTvSeries,
        popularTvSeriesState,
        topRatedTvSeries,
        topRatedTvSeriesState,
        message,
      ];
}
