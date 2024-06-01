import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';

class TopRatedTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  const TopRatedTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  TopRatedTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return TopRatedTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, tvSeries, message];
}
