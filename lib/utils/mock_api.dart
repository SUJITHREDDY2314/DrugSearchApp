import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'hash_content.dart'; // Assuming you have a hash function in this file
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'app_database.db';
  static const String _tableName = 'user';

  // Singleton pattern for the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  // Open and create database
  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the table if it doesn't exist
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        email TEXT NOT NULL PRIMARY KEY,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        dob TEXT NOT NULL
      )
    ''');
  }

  // Insert user into the database
  Future<void> registerUser(
      String email, String password, String fullName, String dob) async {
    var user = {
      'email': email, // Column name as key
      'password': hashPassword(password), // Hashed password
      'full_name': fullName,
      'dob': dob,
    };

    final db = await database;

    // Insert the user into the database
    await db.insert(
      _tableName,
      user,
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Replace if user with the same email exists
    );
  }

  // Retrieve user by email and verify password
  Future<String?> validateLogin(String email) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      // Return the stored hashed password
      final storedHashedPassword = result.first['password'] as String;
      return storedHashedPassword; // Return the hashed password from DB
    }

    return null; // Return null if no user found with the provided email
  }
  Future<Map<String, String>?> getUserDetails(String email) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      final user = result.first;
      return {
        'email': user['email'] as String,
        'full_name': user['full_name'] as String,
        'dob': user['dob'] as String,
      };
    }

    return null; // Return null if no user found
  }
  
  
}

class MockAPI {
  // Simulate a mock API call with a delay (like a network call)
  static Future<bool> validateLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // return await DatabaseHelper().validateLogin(email, password);
    return password == await DatabaseHelper().validateLogin(email);
  }

  static Future<void> registerUser(
      String email, String password, String fullName, String dob) async {
    await DatabaseHelper().registerUser(email, password, fullName, dob);
    print('User registered through MockAPI');
  }

  static Future<Map<String, String>?> getUserDetails(String email) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return await DatabaseHelper().getUserDetails(email);
  }
}
