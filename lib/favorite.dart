import 'package:flutter/material.dart';
import 'db.dart'; // Ensure this import is correct
import 'dart:math';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Dream> favoriteDreams = [];

  // Database helper instance
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadFavoriteDreams();
  }

  // Load favorite dreams from the database
  void _loadFavoriteDreams() async {
    try {
      final dreams =
          await _dbHelper.getAllDreams(); // Fetch all dreams from the database
      setState(() {
        favoriteDreams = dreams
            .where((dream) => dream.isFavorite)
            .toList(); // Filter to get only favorite dreams
        if (favoriteDreams.isEmpty) {
          debugPrint("No favorite dreams found.");
        } else {
          debugPrint("Loaded ${favoriteDreams.length} favorite dreams.");
        }
      });
    } catch (e) {
      debugPrint("Error loading favorite dreams: $e");
    }
  }

  // Toggle favorite status
  void _toggleFavorite(Dream dream) async {
    setState(() {
      dream.isFavorite =
          !dream.isFavorite; // Toggle the favorite status locally
    });
    await _dbHelper.updateDream(dream); // Update the dream in the database
    _loadFavoriteDreams(); // Reload the favorite dreams list
  }

  // Navigate to Dream Detail Screen (without edit or delete options)
  void _showDreamDetails(Dream dream) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(dream: dream),
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the whole screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Use the previously used background image
              fit: BoxFit.cover,
            ),
          ),
          // Main content of the screen wrapped in SafeArea
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // If no favorite dreams, show a message
                  if (favoriteDreams.isEmpty)
                    Expanded(
                      child: Center(
                        child: const Text(
                          'Your favorite dreams will appear here!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  // If there are favorite dreams, display them in a list
                  if (favoriteDreams.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: favoriteDreams.length,
                        itemBuilder: (context, index) {
                          final dream = favoriteDreams[index];
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: Colors.lightBlueAccent.withOpacity(0.2), // Color change for card
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              title: Text(
                                dream.title,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              subtitle: Text(
                                dream.dreamType,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              onTap: () {
                                _showDreamDetails(
                                    dream); // Navigate to DreamDetailScreen when tapped
                              },
                              trailing: IconButton(
                                icon: Image.asset(
                                  dream.isFavorite
                                      ? 'assets/icons/favorite_icon.png' // Custom favorite icon
                                      : 'assets/icons/favorite_border_icon.png', // Custom unfavorite icon
                                  width: 24, // Adjust the icon size
                                  height: 24,
                                ),
                                onPressed: () {
                                  _toggleFavorite(
                                      dream); // Toggle favorite when pressed
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Dream dream;

  const DetailScreen({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the whole screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Background image
              fit: BoxFit.cover,
            ),
          ),
          // Main content of the screen wrapped in SafeArea
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // The card now takes up the entire screen
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                        color: const Color.fromARGB(255, 230, 185, 238)
                            .withOpacity(0.9), // Semi-transparent violet
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Shadow for depth
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Custom Scribbles Painter
                          CustomPaint(
                            size: Size.infinite,
                            painter: ScribblesPainter(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Dream Title (Centered)
                                  Center(
                                    child: Text(
                                      dream.title,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Dream Description
                                  Text(
                                    'Description:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    dream.description,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 20),

                                  // Dream Interpretation
                                  Text(
                                    'Interpretation:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    dream.interpretation,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 20),

                                  // Dream Type
                                  Text(
                                    'Dream Type:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    dream.dreamType,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to add scribbles or little tinglets
class ScribblesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final random = Random();

    // Draw random small circles (representing tinglets or scribbles)
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius =
          random.nextDouble() * 10 + 5; // Random size for the scribbles
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Optionally, you can add more shapes, like lines, to create more scribbles
    paint.strokeWidth = 2;
    for (int i = 0; i < 50; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = random.nextDouble() * size.width;
      final endY = random.nextDouble() * size.height;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint unless the content changes
  }
}
