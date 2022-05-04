import 'dart:async';

import 'package:class_to_map/class_to_map.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import 'book.dart';




class DatabaseHandler {

  late final database;

  DatabaseHandler() {
    WidgetsFlutterBinding.ensureInitialized();
    database ??= _initializeDatabase();
  }

  Future<Database> _initializeDatabase() async {
    var databasePath = await getDatabasesPath();
    var db = openDatabase(
      join(databasePath, 'books_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,author TEXT,genre TEXT,path TEXT, bookmark INTEGER)',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertBook(Book book) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      KBooksDbTable,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Book>> getBooks() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Books.
    final List<Map<String, dynamic>> maps = await db.query(KBooksDbTable);

    return List.generate(maps.length, (i) {
      return maps[i].toClass<Book>();
    });
  }

  Future<void> updateBook(Book book) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      KBooksDbTable,
      book.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      KBooksDbTable,
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

