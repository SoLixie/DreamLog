import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class TrackSleepScreen extends StatefulWidget {
  const TrackSleepScreen({super.key});

  @override
  _TrackSleepScreenState createState() => _TrackSleepScreenState();
}

class _TrackSleepScreenState extends State<TrackSleepScreen> {
  bool isTracking = false; // To track the sleep state
  DateTime sleepStartTime = DateTime.now();
  DateTime sleepEndTime = DateTime.now();
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double previousMagnitude = 0; // To track the magnitude of movement
  final double movementThreshold = 1.5; // Adjust based on sensitivity
  bool isAsleep = false; // To store whether the user is asleep or not
  Duration trackingDuration = Duration.zero; // To track the duration of sleep

  // Function to start accelerometer sensor tracking
  void _startSensorTracking() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate the magnitude of movement based on x, y, z accelerometer values
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      // If the magnitude stays below a certain threshold (indicating the person is still), we assume they're asleep
      if (magnitude < movementThreshold) {
        if (!isAsleep) {
          // The person is likely asleep, so we start tracking sleep
          setState(() {
            isAsleep = true;
            sleepStartTime = DateTime.now(); // Mark the time when sleep started
            isTracking = true; // Start tracking sleep duration
          });
          print("User likely asleep, tracking started.");
        }
      } else {
        // If movement is detected, stop tracking (indicating the person is awake or moving)
        if (isAsleep) {
          setState(() {
            isAsleep = false;
            sleepEndTime = DateTime.now(); // Record the wake-up time
            trackingDuration = sleepEndTime.difference(sleepStartTime); // Calculate duration
            isTracking = false; // Stop tracking
          });
          print("User moving, sleep tracking stopped.");
        }
      }

      if (isTracking) {
        // If tracking is active, continuously update the sleep duration
        setState(() {
          trackingDuration = DateTime.now().difference(sleepStartTime);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startSensorTracking(); // Start accelerometer tracking as soon as the screen loads
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel(); // Clean up accelerometer subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // Add your image path here
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
                isTracking
                    ? Column(
                        children: [
                          // Replace the timer icon with a custom or another icon
                          Image.asset(
                            'assets/icons/timer.png', // Replace with your custom icon path
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Tracking Duration: ${trackingDuration.inMinutes} minutes',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          // Replace the nightlight icon with a custom or another icon
                          Image.asset(
                            'assets/icons/nightlight.png', // Replace with your custom icon path
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