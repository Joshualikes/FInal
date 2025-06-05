import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'workout_model.dart';

  class DBHelper {
  static Future<Database> database() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'fitness.db'),
    version: 2, // 🔁 Increment version to trigger onUpgrade
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE workouts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          details TEXT,
          duration INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE schedule(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          time TEXT,
          task TEXT
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE schedule(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            time TEXT,
            task TEXT
          )
        ''');
      }
    },
  );
}


  static Future<void> insertWorkout(Workout workout) async {
    final db = await DBHelper.database();
    await db.insert('workouts', workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  
  static Future<List<Workout>> fetchWorkouts() async {
    final db = await DBHelper.database();
    final maps = await db.query('workouts');
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  static Future<void> deleteWorkout(int id) async {
    final db = await DBHelper.database();
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateWorkout(Workout workout) async {
    final db = await DBHelper.database();
    await db.update('workouts', workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);
  }
  static Future<void> insertSchedule(Map<String, String> data) async {
    final db = await DBHelper.database();
    await db.insert('schedule', data);
  } 
   static Future<List<Map<String, dynamic>>> getSchedule() async {
    final db = await DBHelper.database();
    return db.query('schedule');
    
  }
    static Future<void> deleteSchedule(int id) async {
    final db = await DBHelper.database();
    await db.delete('schedule', where: 'id = ?', whereArgs: [id]);
  }

}
