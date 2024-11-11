import 'package:flutter/material.dart';
import 'db.dart'; // Import the DB helper

class DreamListScreen extends StatefulWidget {
  const DreamListScreen({Key? key}) : super(key: key);

  @override
  _DreamListScreenState createState() => _DreamListScreenState();
}

class _DreamListScreenState extends State<DreamListScreen> {
  List<Dream> dreams = [];
  List<Dream> filteredDreams = [];  // Filtered list of dreams based on the search query
  TextEditingController searchController = TextEditingController();  // Controller for the search bar

  // Load dreams from the database
  void _loadDreams() async {
    final fetchedDreams = await DatabaseHelper().getAllDreams();  // Use DB helper to fetch data
    if (mounted) {
      setState(() {
        dreams = fetchedDreams;
        filteredDreams = dreams;  // Initially, show all dreams
      });
    }
  }

  // Filter dreams based on the search query
  void _filterDreams(String query) {
    final filtered = dreams.where((dream) {
      return dream.title.toLowerCase().contains(query.toLowerCase()) || 
             dream.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDreams = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDreams();  // Load dreams when the screen is initialized
    searchController.addListener(() {
      _filterDreams(searchController.text);  // Update filtered list when the search query changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Keep left and right padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Increased space between the top and search bar
              const SizedBox(height: 100),  // Increase the height to push search bar further down

              // Search bar inside the same container as the dreams list
              Container(
                padding: const EdgeInsets.all(8.0),  // Added padding around the search bar
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),  // Background color for search bar
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.black),  // Set input text color to black
                  decoration: InputDecoration(
                    hintText: "Search dreams...",
                    hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/icons/search.png',  // Use your custom search icon
                        width: 20, // Adjust icon size
                        height: 20, // Adjust icon size
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),  // Space between search bar and list
              filteredDreams.isEmpty
                  ? const Center(
                      child: Text(
                        "No dreams available.",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredDreams.length,
                        itemBuilder: (context, index) {
                          final dream = filteredDreams[index];
                          return Card(
                            color: Colors.lightBlueAccent.withOpacity(0.2), // Color change for card
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 4), // Reduced card margin
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              title: Text(
                                dream.title,
                                style: const TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              subtitle: Text(
                                dream.dreamType,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              onTap: () {
                                // Do nothing when tapping the dream
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Image.asset('assets/icons/edit.png', width: 24, height: 24),
                                    onPressed: () => _editDream(dream),
                                  ),
                                  IconButton(
                                    icon: Image.asset('assets/icons/delete.png', width: 24, height: 24),
                                    onPressed: () => _deleteDream(dream.id!),
                                  ),
                                  IconButton(
                                    icon: Image.asset(
                                      dream.isFavorite
                                          ? 'assets/icons/favorite_icon.png'
                                          : 'assets/icons/favorite_border_icon.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed: () => _toggleFavorite(dream),
                                    color: dream.isFavorite ? Colors.yellow : Colors.grey,
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
    );
  }

  // Edit dream
  void _editDream(Dream dream) {
    TextEditingController editTitleController = TextEditingController(text: dream.title);
    TextEditingController editDescriptionController = TextEditingController(text: dream.description);
    TextEditingController editInterpretationController = TextEditingController(text: dream.interpretation);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50], // Custom background color for AlertDialog
          title: const Text(
            "Edit Dream",
            style: TextStyle(color: Colors.black), // Title color
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Title",
                  style: TextStyle(color: Colors.black), // Title field color
                ),
                TextField(
                  controller: editTitleController,
                  decoration: const InputDecoration(
                    hintText: "Edit your dream title",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text("Description", style: TextStyle(color: Colors.black)),
                TextField(
                  controller: editDescriptionController,
                  decoration: const InputDecoration(
                    hintText: "Edit description",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text("Interpretation", style: TextStyle(color: Colors.black)),
                TextField(
                  controller: editInterpretationController,
                  decoration: const InputDecoration(
                    hintText: "Edit interpretation",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Update dream with new values
                dream.title = editTitleController.text;
                dream.description = editDescriptionController.text;
                dream.interpretation = editInterpretationController.text;
                await DatabaseHelper().updateDream(dream);  // Update the dream in DB
                _loadDreams();  // Reload the dreams list
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.teal), // Custom color for Save button
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red), // Custom color for Cancel button
              ),
            ),
          ],
        );
      },
    );
  }

  // Delete dream
  void _deleteDream(int id) async {
    await DatabaseHelper().deleteDream(id);  // Delete the dream from DB
    _loadDreams();  // Reload the dreams list
  }

  // Toggle favorite status
  void _toggleFavorite(Dream dream) async {
    await DatabaseHelper().toggleFavorite(dream.id!);  // Toggle favorite status in DB
    _loadDreams();  // Reload the dreams list
  }
}