import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // This is the name of our database file
  static const _databaseName = "WellnessDiary_v2.db";
  static const _databaseVersion = 1;

  // Make this a "Singleton" (meaning there is only ONE filing cabinet in the whole app)
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // This opens the cabinet. If it doesn't exist, it builds it!
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // This is where we build the cabinet and the drawers (tables)
  _initDatabase() async {
    // Find the safe folder on the phone to store our data
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Open the database and create the tables
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Here we write simple SQL to create our tables (like creating columns on a piece of paper)
  // Here we write simple SQL to create our tables
  Future _onCreate(Database db, int version) async {
    // Drawer 1: Vitals
    await db.execute('''
          CREATE TABLE vitals_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            systolic INTEGER NOT NULL,
            diastolic INTEGER NOT NULL,
            pulse INTEGER NOT NULL,
            date TEXT NOT NULL
          )
          ''');

    // Drawer 2: Mood
    await db.execute('''
          CREATE TABLE mood_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mood_score INTEGER NOT NULL,
            date TEXT NOT NULL
          )
          ''');

    // Drawer 3: Medications (NEW!)
    await db.execute('''
          CREATE TABLE meds_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            drug_name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            time_to_take TEXT NOT NULL,
            status INTEGER NOT NULL
          )
          ''');
  }
}
