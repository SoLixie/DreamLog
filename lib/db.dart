import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Dream {
  int? id;  
  String title;  
  String? _description;  
  String dreamType;  
  String interpretation;  
  bool isFavorite;  
  String? date;  

  Dream({
    this.id,
    required this.title,
    String? description,  
    required this.dreamType,
    required this.interpretation,
    this.isFavorite = false,  
    this.date,  
  }) : _description = description;

  String get description => _description ?? '';

  set description(String value) {
    _description = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': _description,  
      'dreamType': dreamType,
      'interpretation': interpretation,
      'isFavorite': isFavorite ? 1 : 0,  
      'date': date,  
    };
  }

  factory Dream.fromMap(Map<String, dynamic> map) {
    return Dream(
      id: map['id'],
      title: map['title'],
      description: map['description'], 
      dreamType: map['dreamType'],
      interpretation: map['interpretation'],
      isFavorite: map['isFavorite'] == 1,  
      date: map['date'],  
    );
  }

  @override
  String toString() {
    return 'Dream(id: $id, title: $title, description: $description, dreamType: $dreamType, interpretation: $interpretation, isFavorite: $isFavorite, date: $date)';
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'dreams.db',  
      version: 2,  
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dreams(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            dreamType TEXT,
            interpretation TEXT,
            isFavorite INTEGER,
            date TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE dreams ADD COLUMN date TEXT
          ''');
        }
      },
    );
  }

  Future<int> insertDream(Dream dream) async {
    final db = await database;
    return await db.insert('dreams', dream.toMap());
  }

  Future<Dream?> getDreamById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dreams',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Dream.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Dream>> getAllDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dreams');
    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }

  Future<int> updateDream(Dream dream) async {
    final db = await database;
    return await db.update(
      'dreams',
      dream.toMap(),
      where: 'id = ?',
      whereArgs: [dream.id],
    );
  }

  Future<int> deleteDream(int id) async {
    final db = await database;
    return await db.delete(
      'dreams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleFavorite(int id) async {
    final db = await database;
    final dream = await getDreamById(id);
    if (dream != null) {
      dream.isFavorite = !dream.isFavorite;
      return await updateDream(dream);
    }
    return 0;
  }

  Future<List<Dream>> searchDreams(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dreams',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }
}