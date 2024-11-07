import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dream {
  int? id;
  String title;
  String description;
  String date;
  double sleepDuration;
  bool isFavorite;
  String? interpretation; // Add the interpretation field

  Dream({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.sleepDuration,
    this.isFavorite = false,
    this.interpretation, // Add the interpretation parameter
  });

  // Convert a Dream object into a Map object, including interpretation
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'sleepDuration': sleepDuration,
      'is_favorite': isFavorite ? 1 : 0,
      'interpretation': interpretation, // Save the interpretation
    };
  }

  // Convert a Map object into a Dream object, including interpretation
  factory Dream.fromMap(Map<String, dynamic> map) {
    return Dream(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      sleepDuration: map['sleepDuration'],
      isFavorite: map['is_favorite'] == 1,
      interpretation: map['interpretation'], // Fetch interpretation
    );
  }
}

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'dreams.db');
    return await openDatabase(
      path,
      version: 3, // Increment version to 3 for schema update
      onCreate: (db, version) async {
        // Create the table with the is_favorite and interpretation columns
        await db.execute(
          'CREATE TABLE dreams(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT, sleepDuration REAL, is_favorite INTEGER, interpretation TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle database upgrade (e.g., adding the interpretation and is_favorite columns)
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE dreams ADD COLUMN interpretation TEXT', // Add interpretation column
          );
        }
      },
    );
  }

  Future<List<Dream>> getDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dreams');
    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }

  Future<void> insertDream(Dream dream) async {
    final db = await database;
    await db.insert(
      'dreams',
      dream.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDream(Dream dream) async {
    final db = await database;
    await db.update(
      'dreams',
      dream.toMap(),
      where: 'id = ?',
      whereArgs: [dream.id],
    );
  }

  Future<void> deleteDream(int id) async {
    final db = await database;
    await db.delete(
      'dreams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to update the favorite status of a dream
  Future<void> updateFavoriteStatus(int dreamId, bool isFavorite) async {
    final db = await database;
    await db.update(
      'dreams',
      {'is_favorite': isFavorite ? 1 : 0}, // Update the favorite status
      where: 'id = ?',
      whereArgs: [dreamId],
    );
  }

  // Additional method to get only favorite dreams
  Future<List<Dream>> getFavoriteDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dreams',
      where: 'is_favorite = ?',
      whereArgs: [1], // Only get favorites
    );
    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }
}