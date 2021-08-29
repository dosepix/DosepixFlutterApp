import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler with ChangeNotifier {
  final _databaseName = 'dosepix.db';
  static Database? _db;

  List<String> tableName = ["test", "test2"];


  Future<Database> get db async {
    return _db ??= await _initializeDB(_databaseName);
  }

  Future<Database> _initializeDB(String fileName) async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, fileName),
      onCreate: (database, version) async {
      },
      version: 1,
    );
  }

  void _createTable(Database db, version) async {
    Batch batch = db.batch();
    List<int>.generate(tableName.length, (i) => i +1)
      .map((i) {
        batch.execute('''
          CREATE TABLE ${tableName[i]} (
        )''');
    });
    await batch.commit();
  }
}
