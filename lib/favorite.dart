import 'package:flutter/material.dart';
import 'db.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Dream> favoriteDreams = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteDreams();
  }

  // Load favorite dreams from the database
  void _loadFavoriteDreams() async {
    final dreams = await DBHelper().getFavoriteDreams();
    setState(() {
      favoriteDreams = dreams;
    });
  }

  // Toggle favorite status
  void _toggleFavorite(Dream dream) async {
    await DBHelper().updateFavoriteStatus(dream.id!, !dream.isFavorite);
    _loadFavoriteDreams(); // Reload the favorite dreams after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the whole screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content of the screen
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (favoriteDreams.isEmpty)
                    const Text(
                      'Your favorite dreams will appear here!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (favoriteDreams.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: favoriteDreams.length,
                        itemBuilder: (context, index) {
                          final dream = favoriteDreams[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(
                                dream.title,
                                style: const TextStyle(fontSize: 18),
                              ),
                              leading: const Icon(Icons.star, color: Color(0xFF4A90E2)),
                              trailing: IconButton(
                                icon: Icon(
                                  dream.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                ),
                                onPressed: () {
                                  _toggleFavorite(dream);
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