import 'package:flutter/material.dart';
import 'add_dream.dart';
import 'dream_list.dart';
import 'track_sleep.dart';
import 'favorite.dart';
import 'dream_interpretation.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures the body extends beneath the AppBar and BottomNavigationBar
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0, // Remove the elevation for a flat design
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image covering the whole screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Path to your background image
              fit: BoxFit.cover,
            ),
          ),
          // Main content of the screen
          Column(
            children: [
              // Search bar at the top
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Dreams...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                onSubmitted: (value) {},
              ),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0, // No horizontal spacing
                  mainAxisSpacing: 0.0,  // No vertical spacing
                  children: [
                    _buildCard(
                      context,
                      'assets/icons/interpret.png', // Custom icon path for Dream Interpretation
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
                      'assets/icons/track.png', // Custom icon path for Track Sleep
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
                      'assets/icons/favorite.png', // Custom icon path for Favorites
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
                      'assets/icons/list.png', // Custom icon path for Dream List
                      'Dream List',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DreamListScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDreamScreen()),
          );
        },
        backgroundColor: const Color(0xFF4A90E2),
        child: Image.asset('assets/icons/add.png', width: 30, height: 30), // Custom icon for FAB
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 30, height: 30), // Custom Home Icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/setting.png', width: 30, height: 30), // Custom Settings Icon
            label: 'App Settings',
          ),
        ],
      ),
    );
  }

  // Updated _buildCard function using custom icons
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
                width: 50, 
                height: 50, // Adjust size if necessary
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}