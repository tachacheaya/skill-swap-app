import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillswapproj/screens/CategoryResultsPage.dart';

class SearchCategoryPage extends StatefulWidget {
  const SearchCategoryPage({super.key});

  @override
  State<SearchCategoryPage> createState() => _SearchCategoryPageState();
}

class _SearchCategoryPageState extends State<SearchCategoryPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {"name": "Music", "icon": Icons.music_note},
    {"name": "Photography", "icon": Icons.camera_alt},
    {"name": "Cooking", "icon": Icons.restaurant_menu},
    {"name": "Painting", "icon": Icons.brush},
    {"name": "Languages", "icon": Icons.language},
    {"name": "Mobile Development", "icon": Icons.computer},
  ];

  final List<Map<String, String>> allUsers = [
    {
      "name": "sarah",
      "skill": "Painting",
      "location": "Oran",
      "image": "assets/images/pic2.jpg",
      "description": "I have been doing wall painting for 3 years.",
      "level": "3"
    },
    {
      "name": "mohamed",
      "skill": "Music",
      "location": "Alger",
      "image": "assets/images/pic.jpg",
      "description": "Passionate guitarist and music teacher.",
      "level": "4"
    },
    {
      "name": "fella",
      "skill": "Photography",
      "location": "Annaba",
      "image": "assets/images/pic3.jpg",
      "description": "Wedding and nature photographer.",
      "level": "3"
    },
    {
      "name": "Aymen",
      "skill": "Mobile Development",
      "location": "Medea",
      "image": "assets/images/pic5.jpg",
      "description": "Mobile Application developer for IOS and Android,using flutter .",
      "level": "5"
    },
    {
      "name": "Aya",
      "skill": "Cooking",
      "location": "Mila",
      "image": "assets/images/pic7.jpg",
      "description": "Professional chef, fan of oriental cuisine .",
      "level": "5"
    },
    {
      "name": "Arwa",
      "skill": "Marketing",
      "location": "oran",
      "image": "assets/images/pic8.jpg",
      "description": "Create and manage strategies to promote products and attract customers.",
      "level": "4",
    },
  ];

  void _search(String skillQuery) {
    final query = skillQuery.toLowerCase();
    final results = allUsers
        .where((user) => user["skill"]!.toLowerCase().contains(query))
        .toList();

    if (results.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(results: results),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No results found for this category.",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFFCA5A5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2F6), // Pastel pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Explore Categories",
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B3A7A), // Deep purple for contrast
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4B3A7A)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Find Your Skill",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4B3A7A),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search for skills (e.g., Music, Cooking)",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0xFFEDE9FE), // Pastel purple
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFFD8B4FE), // Light purple
                  ),
                  onPressed: () => _search(_controller.text),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD8B4FE),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD8B4FE),
                    width: 2,
                  ),
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: categories.map((cat) {
                  return GestureDetector(
                    onTap: () => _search(cat["name"]!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFE4E6), // Pastel pink
                            Color(0xFFEDE9FE), // Pastel purple
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD8B4FE), // Light purple
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              cat["icon"],
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            cat["name"]!,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF4B3A7A),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}