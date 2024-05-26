import 'package:submission_flutter_expert/common/exception.dart';
import 'package:submission_flutter_expert/data/datasources/db/database_helper.dart';
import 'package:submission_flutter_expert/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlistTvSeries(TvTable tvSeries);
  Future<String> removeWatchlistTvSeries(TvTable tvSeries);
  Future<TvTable?> getTvSeriesById(int id);
  Future<List<TvTable>> getWatchlistTvSeries();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlistTvSeries(TvTable tvSeries) async {
    try {
      await databaseHelper.insertWatchlistTvSeries(tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTvSeries(TvTable tvSeries) async {
    try {
      await databaseHelper.removeWatchlistTvSeries(tvSeries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
