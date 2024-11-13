import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';

// The class for tracking the sleep
class TrackSleepScreen extends StatefulWidget {
  const TrackSleepScreen({super.key});

  @override
  _TrackSleepScreenState createState() => _TrackSleepScreenState();
}

class _TrackSleepScreenState extends State<TrackSleepScreen> {
  bool isTracking = false;
  DateTime sleepStartTime = DateTime.now();
  DateTime sleepEndTime = DateTime.now();
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double previousMagnitude = 0;
  final double movementThreshold = 1.5;
  bool isAsleep = false;
  Duration trackingDuration = Duration.zero;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Function to start tracking using the accelerometer
  void _startSensorTracking() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (magnitude < movementThreshold) {
        if (!isAsleep) {
          setState(() {
            isAsleep = true;
            sleepStartTime = DateTime.now();
            isTracking = true;
          });
          print("User likely asleep, tracking started.");
        }
      } else {
        if (isAsleep) {
          setState(() {
            isAsleep = false;
            sleepEndTime = DateTime.now();
            trackingDuration = sleepEndTime.difference(sleepStartTime);
            isTracking = false;
          });
          print("User moving, sleep tracking stopped.");
          _saveSleepData(); // Save sleep data when tracking ends
        }
      }

      if (isTracking) {
        setState(() {
          trackingDuration = DateTime.now().difference(sleepStartTime);
        });
      }
    });
  }

  // Function to save sleep data to the database
  Future<void> _saveSleepData() async {
    final sleepData = SleepData(
      startTime: sleepStartTime.toIso8601String(),
      endTime: sleepEndTime.toIso8601String(),
      duration: trackingDuration.inMinutes,
    );
    await _databaseHelper.insertSleepData(sleepData);
    print("Sleep data saved.");
  }

  @override
  void initState() {
    super.initState();
    _startSensorTracking();
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Track Your Sleep Duration',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Show tracking duration while tracking is active
                if (isTracking)
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/timer.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tracking Duration: ${trackingDuration.inMinutes} min',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'You\'re asleep!',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/nightlight.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Waiting for you to fall asleep...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sleep History Button for accessing history screen
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SleepHistoryScreen(),
                            ),
                          );
                        },
                        child: const Text('View Sleep History'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Sleep Data Model
class SleepData {
  final String startTime;
  final String endTime;
  final int duration;

  SleepData({
    required this.startTime,
    required this.endTime,
    required this.duration,
  });
}

// Database Helper Class (to interact with the database)
class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'sleep_data.db', 
      version: 1, 
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE sleep_data(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            startTime TEXT,
            endTime TEXT,
            duration INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertSleepData(SleepData sleepData) async {
    final db = await database;
    return await db.insert('sleep_data', {
      'startTime': sleepData.startTime,
      'endTime': sleepData.endTime,
      'duration': sleepData.duration,
    });
  }

  Future<List<SleepData>> getAllSleepData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sleep_data');
    return List.generate(maps.length, (i) {
      return SleepData(
        startTime: maps[i]['startTime'],
        endTime: maps[i]['endTime'],
        duration: maps[i]['duration'],
      );
    });
  }
}

class SleepHistoryScreen extends StatelessWidget {
  const SleepHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sleep History")),
      body: FutureBuilder<List<SleepData>>(
        future: DatabaseHelper().getAllSleepData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No sleep data found"));
          }

          final sleepData = snapshot.data!;
          return ListView.builder(
            itemCount: sleepData.length,
            itemBuilder: (context, index) {
              final data = sleepData[index];
              return ListTile(
                title: Text("Duration: ${data.duration} minutes"),
                subtitle: Text("Start: ${data.startTime}\nEnd: ${data.endTime}"),
              );
            },
          );
        },
      ),
    );
  }
}
