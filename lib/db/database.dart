import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:midterm/model/book.dart';

class BooksDatabase {
  static final BooksDatabase instance = BooksDatabase._init();
  static Database? _database;
  BooksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('Books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableBooks ( 
  ${BookFields.id} $idType, 
  ${BookFields.title} $textType,
  ${BookFields.description} $textType,
  ${BookFields.image} $textType,
  ${BookFields.time} $textType
  )
''');
  }

  Future<Book> create(Book Book) async {
    final db = await instance.database;

    final id = await db.insert(tableBooks, Book.toJson());
    return Book.copy(id: id);
  }

  Future<Book> readBook(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBooks,
      columns: BookFields.values,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;

    final orderBy = '${BookFields.time} ASC';

    final result = await db.query(tableBooks, orderBy: orderBy);

    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> update(Book Book) async {
    final db = await instance.database;

    return db.update(
      tableBooks,
      Book.toJson(),
      where: '${BookFields.id} = ?',
      whereArgs: [Book.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableBooks,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
