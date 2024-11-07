import 'package:flutter/material.dart';
import 'db.dart'; // Make sure to import the Dream and DBHelper classes

class DreamListScreen extends StatefulWidget {
  const DreamListScreen({super.key});

  @override
  _DreamListScreenState createState() => _DreamListScreenState();
}

class _DreamListScreenState extends State<DreamListScreen> {
  // List to store the dreams fetched from the database
  List<Dream> dreams = [];

  // Fetch the list of dreams from the database
  void _loadDreams() async {
    final fetchedDreams = await DBHelper().getDreams();
    setState(() {
      dreams = fetchedDreams;
    });
  }

  // Edit dream functionality
  void _editDream(Dream dream) {
    TextEditingController _editController =
        TextEditingController(text: dream.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Dream"),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(
              hintText: "Edit your dream",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Update the dream in the database
                dream.title = _editController.text; // Update the title
                await DBHelper().updateDream(dream);
                _loadDreams(); // Reload the dreams after update
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Delete dream functionality
  void _deleteDream(int id) async {
    await DBHelper().deleteDream(id); // Delete dream from database
    _loadDreams(); // Reload the dreams after deletion
  }

  @override
  void initState() {
    super.initState();
    _loadDreams(); // Load dreams when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream List'),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        centerTitle: true,
        leading: Container(), // No back button
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Check if the list is empty
                  if (dreams.isEmpty)
                    const Text(
                      "No dreams available.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  // Dream List
                  Expanded(
                    child: ListView.builder(
                      itemCount: dreams.length,
                      itemBuilder: (context, index) {
                        final dream = dreams[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              dream.title,
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editDream(dream); // Edit the dream
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteDream(dream.id!); // Delete the dream
                                  },
                                ),
                              ],
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