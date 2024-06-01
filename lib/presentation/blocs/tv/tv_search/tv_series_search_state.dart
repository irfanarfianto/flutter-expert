import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';


class TvSeriesSearchState extends Equatable {
  final RequestState state;
  final List<TvSeries> searchResult;
  final String message;

  const TvSeriesSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  TvSeriesSearchState copyWith({
    RequestState? state,
    List<TvSeries>? searchResult,
    String? message,
  }) {
    return TvSeriesSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, searchResult, message];
}
