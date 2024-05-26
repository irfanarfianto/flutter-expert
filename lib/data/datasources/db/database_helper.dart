import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:submission_flutter_expert/data/models/movie_table.dart';
import 'package:submission_flutter_expert/data/models/tv_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tblWatchlist (
      id INTEGER PRIMARY KEY,
      title TEXT,
      overview TEXT,
      posterPath TEXT,
      type TEXT
    );
  ''');
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, {
      'id': movie.id,
      'title': movie.title,
      'overview': movie.overview,
      'posterPath': movie.posterPath,
      'type': 'movie',
    });
  }

  Future<int> insertWatchlistTvSeries(TvTable tvSeries) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, {
      'id': tvSeries.id,
      'title': tvSeries.name,
      'overview': tvSeries.overview,
      'posterPath': tvSeries.posterPath,
      'type': 'tvSeries',
    });
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [movie.id, 'movie'],
    );
  }

  Future<int> removeWatchlistTvSeries(TvTable tvSeries) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [tvSeries.id, 'tvSeries'],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [id, 'movie'],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [id, 'tvSeries'],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = ?',
      whereArgs: ['movie'],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = ?',
      whereArgs: ['tvSeries'],
    );

    return results;
  }
}
