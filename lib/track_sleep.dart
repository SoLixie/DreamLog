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

  // Function to toggle the sleep tracking
  void _toggleSleepTracking() {
    setState(() {
      if (isTracking) {
        sleepEndTime = DateTime.now();
        trackingDuration = sleepEndTime.difference(sleepStartTime);
        _accelerometerSubscription.cancel(); // Stop tracking
      } else {
        sleepStartTime = DateTime.now();
        trackingDuration = Duration.zero; // Reset duration when starting
        _startSensorTracking(); // Start tracking sensors
      }
      isTracking = !isTracking;
    });
  }

  // Function to start accelerometer sensor tracking
  void _startSensorTracking() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate the magnitude of movement based on x, y, z accelerometer values
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      // Check if the magnitude is less than the threshold (indicating little to no movement)
      if (magnitude < movementThreshold) {
        // If magnitude stays low for a certain amount of time, assume the user is asleep
        if (!isAsleep) {
          isAsleep = true;
          print("User likely asleep");
        }
      } else {
        // If movement is detected, reset the sleep state
        if (isAsleep) {
          isAsleep = false;
          print("User moving, not asleep");
        }
      }

      // Store previous magnitude for future comparison
      previousMagnitude = magnitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Sleep Duration'),
        backgroundColor: const Color(0xFF1E1E78),
        elevation: 0,
        centerTitle: true,
        leading: Container(),
      ),
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
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _toggleSleepTracking,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C2C54),
                              minimumSize: const Size(200, 50),
                            ),
                            icon: Image.asset(
                              'assets/icons/stop.png', // Custom stop timer icon
                              width: 30,
                              height: 30,
                            ),
                            label: const Text('Stop Tracking'),
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
                            'Start tracking your sleep!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _toggleSleepTracking,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C2C54),
                              minimumSize: const Size(200, 50),
                            ),
                             icon: Image.asset(
                              'assets/icons/play.png', // Custom stop timer icon
                              width: 30,
                              height: 30,
                            ),
                            label: const Text('Start Tracking'),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}