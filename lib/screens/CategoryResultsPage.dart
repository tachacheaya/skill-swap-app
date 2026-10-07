import 'package:flutter/material.dart';
import 'chatrequest_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final List<Map<String, String>> results;

  const SearchResultScreen({super.key, required this.results});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late List<Map<String, String>> filteredUsers;

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(widget.results); // clone pour modification locale
  }

  void _handleLike(Map<String, String> user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRequestScreen(
          userName: user['name'] ?? '',
          skill: user['skill'] ?? '',
          imagePath: user['image'] ?? '',
        ),
      ),
    );

    if (result == 'sent') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message sent successfully")),
      );
    }
  }

  void _handleDislike(int index) {
    setState(() {
      filteredUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0FF),
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: const Text("Search Results", style: TextStyle(color: Colors.deepPurple)),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: filteredUsers.isEmpty
          ? const Center(
              child: Text(
                "No users found with this skill.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB6F9), Color(0xFFB28DFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(user['image'] ?? ''),
                        radius: 28,
                      ),
                      title: Text(
                        user['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                      subtitle: Text(
                        user['skill'] ?? '',
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.white),
                            onPressed: () => _handleLike(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => _handleDislike(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
