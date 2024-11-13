import 'package:flutter/material.dart';
import 'add_dream.dart' as add_dream; // Alias for AddDreamScreen import
import 'dream_list.dart' as dream_list; // Alias for DreamListScreen import
import 'track_sleep.dart';
import 'favorite.dart';
import 'dream_interpretation.dart';
import 'settings.dart'; // Importing the SettingsScreen

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Extends body beneath BottomNavigationBar
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40), // Space at the top for layout consistency
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      _buildCard(
                        context,
                        'assets/icons/interpret.png',
                        'Dream Interpretation',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DreamInterpretationScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        'assets/icons/track.png',
                        'Track Sleep',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TrackSleepScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        'assets/icons/favorite.png',
                        'Favorites',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        'assets/icons/list.png',
                        'Dream List',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const dream_list.DreamListScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const add_dream.AddDreamScreen()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 191, 96, 182),
          child: Image.asset('assets/icons/add.png', width: 30, height: 30),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()), // Navigate to SettingsScreen
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 30, height: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/setting.png', width: 30, height: 30),
            label: 'App Settings',
          ),
        ],
      ),
    );
  }

  // Card builder method for consistency
  Widget _buildCard(BuildContext context, String iconPath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: const Color(0xFFEBF0F5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
