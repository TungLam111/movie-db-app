import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/movie_table.dart';

class MovieDatabaseHelper {
  MovieDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory MovieDatabaseHelper() =>
      _databaseHelper ?? MovieDatabaseHelper._instance();
  static MovieDatabaseHelper? _databaseHelper;

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _movieWatchlistTable = 'movieWatchlistTable';

  Future<Database> _initDb() async {
    final String path = await getDatabasesPath();
    final String databasePath = '$path/movie.db';

    Database db =
        await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE  $_movieWatchlistTable (
        releaseDate TEXT,
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        voteAverage DOUBLE
      );
    ''',
    );
  }

  Future<int> insertMovieWatchlist(MovieTable movie) async {
    final Database? db = await database;
    return await db!.insert(_movieWatchlistTable, movie.toMap());
  }

  Future<int> removeMovieWatchlist(MovieTable movie) async {
    final Database? db = await database;
    return await db!.delete(
      _movieWatchlistTable,
      where: 'id = ?',
      whereArgs: <Object?>[movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final Database? db = await database;
    final List<Map<String, Object?>> results = await db!.query(
      _movieWatchlistTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_movieWatchlistTable);

    return results;
  }
}
