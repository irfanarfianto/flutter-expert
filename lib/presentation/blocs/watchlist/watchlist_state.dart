import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';

class WatchlistState extends Equatable {
  final RequestState watchlistState;
  final List<dynamic> watchlist;
  final String message;

  const WatchlistState({
    this.watchlistState = RequestState.Empty,
    this.watchlist = const [],
    this.message = '',
  });

  WatchlistState copyWith({
    RequestState? watchlistState,
    List<dynamic>? watchlist,
    String? message,
  }) {
    return WatchlistState(
      watchlistState: watchlistState ?? this.watchlistState,
      watchlist: watchlist ?? this.watchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistState, watchlist, message];
}
