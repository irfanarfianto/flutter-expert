import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';

class TvListState extends Equatable {
  final List<TvSeries> nowPlayingTvSeries;
  final RequestState nowPlayingState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedState;
  final String message;

  const TvListState({
    this.nowPlayingTvSeries = const [],
    this.nowPlayingState = RequestState.Empty,
    this.popularTvSeries = const [],
    this.popularState = RequestState.Empty,
    this.topRatedTvSeries = const [],
    this.topRatedState = RequestState.Empty,
    this.message = '',
  });

  TvListState copyWith({
    List<TvSeries>? nowPlayingTvSeries,
    RequestState? nowPlayingState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedState,
    String? message,
  }) {
    return TvListState(
      nowPlayingTvSeries: nowPlayingTvSeries ?? this.nowPlayingTvSeries,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularState: popularState ?? this.popularState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedState: topRatedState ?? this.topRatedState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingTvSeries,
        nowPlayingState,
        popularTvSeries,
        popularState,
        topRatedTvSeries,
        topRatedState,
        message,
      ];
}
