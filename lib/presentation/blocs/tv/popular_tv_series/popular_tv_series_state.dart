import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';


class PopularTvSeriesState extends Equatable {
  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  const PopularTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  PopularTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return PopularTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, tvSeries, message];
}
