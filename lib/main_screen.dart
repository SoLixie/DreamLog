import 'package:flutter/material.dart';
import 'add_dream.dart' as add_dream; // Alias for AddDreamScreen import
import 'dream_list.dart' as dream_list; // Alias for DreamListScreen import
import 'track_sleep.dart';
import 'favorite.dart';
import 'dream_interpretation.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures the body extends beneath the BottomNavigationBar
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
          Padding(
            padding: const EdgeInsets.all(16.0),  // Add padding around the GridView
            child: Column(
              children: [
                const SizedBox(height: 40),  // Adjusted space for layout after removing AppBar
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0, // Horizontal spacing between cards
                    mainAxisSpacing: 16.0,  // Vertical spacing between cards
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
                            MaterialPageRoute(builder: (context) => const dream_list.DreamListScreen()), // Use alias
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
        padding: const EdgeInsets.only(bottom: 16.0), // Add bottom padding to FAB
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const add_dream.AddDreamScreen()), // Use alias
            );
          },
          backgroundColor: const Color.fromARGB(255, 191, 96, 182),
          child: Image.asset('assets/icons/add.png', width: 30, height: 30), // Custom icon for FAB
        ),
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
                width: 60,  // Increase icon size for better visibility
                height: 60,
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