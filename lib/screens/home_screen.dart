import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skillswapproj/screens/chatrequest_screen.dart';
import 'package:skillswapproj/screens/fullchat.dart';
import 'package:skillswapproj/screens/profile_screen.dart';
import 'package:skillswapproj/screens/search_screen.dart';
import 'package:skillswapproj/screens/settings_screen.dart';
import 'package:skillswapproj/screens/login_screen.dart';
import 'pro_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final CardSwiperController _controller = CardSwiperController();
  late AnimationController _animationController;

  List<Map<String, String>> users = [
    {
      "name": "Sarah",
      "skill": "Painting",
      "location": "Oran",
      "image": "assets/images/pic2.jpg",
      "description": "I have been doing wall painting for 3 years.",
      "isOnline": "true"
    },
    {
      "name": "Mohamed",
      "skill": "Music",
      "location": "Alger",
      "image": "assets/images/pic.jpg",
      "description": "Passionate guitarist and music teacher.",
      "isOnline": "false"
    },
    {
      "name": "Fella",
      "skill": "Photography",
      "location": "Annaba",
      "image": "assets/images/pic3.jpg",
      "description": "Wedding and nature photographer.",
      "isOnline": "true"
    },
    {
      "name": "Aymen",
      "skill": "Mobile Development",
      "location": "Medea",
      "image": "assets/images/pic5.jpg",
      "description": "Mobile Application developer for iOS and Android, using Flutter.",
      "isOnline": "false"
    },
    {
      "name": "Aya",
      "skill": "Cooking",
      "location": "Mila",
      "image": "assets/images/pic7.jpg",
      "description": "Professional chef, fan of oriental cuisine.",
      "isOnline": "true"
    },
    {
      "name": "Arwa",
      "skill": "Marketing",
      "location": "oran",
      "image": "assets/images/pic8.jpg",
      "description": "Create and manage strategies to promote products and attract customers.",
      "isOnline": "true"
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => SearchCategoryPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => FullChatPage()));
        break;
    }
  }

  void _handleLike(String name, String skill, String imagePath) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRequestScreen(
          userName: name,
          skill: skill,
          imagePath: imagePath,
        ),
      ),
    );

    if (result == 'sent') {
      _showSentMessageDialog();
    }
  }

  void _handleDislike(int index) {
    setState(() {
      if (users.isNotEmpty) {
        users.removeAt(index);
      }
    });
  }

  void _showSentMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.1),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/icons/puzzle.png", height: 80),
            const SizedBox(height: 12),
            const Text(
              "Your message has been sent",
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.purple)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Report $userName",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.report, color: Colors.red, size: 24),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let the admin know what's wrong with this user.\nNo one else will see your name on this report.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildReportOption("Spam"),
            _buildReportOption("Harassment Comments"),
            _buildReportOption("Hate Speech"),
            _buildReportOption("Inappropriate Profile Pictures"),
            _buildReportOption("Other"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          _showConfirmationDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          reason,
          style: const TextStyle(color: Colors.purple, fontSize: 16),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.1),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            const SizedBox(height: 12),
            const Text(
              "The user has been reported to our support team for review. Thank you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.purple)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Skill Swap",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProPage()));
                },
                icon: const Icon(Icons.workspace_premium, size: 20, color: Colors.purple),
                label: const Text(
                  "Pro",
                  style: TextStyle(fontSize: 14, color: Colors.purple),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 2,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple.shade200,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.pink.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: users.isEmpty
                    ? const Center(
                        child: Text(
                          "No more profiles to show.",
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      )
                    : CardSwiper(
                        controller: _controller,
                        cardsCount: users.length,
                        numberOfCardsDisplayed: 1,
                        isLoop: false,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        cardBuilder: (context, index, percentX, percentY) {
                          final user = users[index];
                          return Center(
                            child: SizedBox(
                              width: 360,
                              height: 560,
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.purple.shade800.withOpacity(0.3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(user["image"]!),
                                            radius: 60,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "${user["name"]!} - ${user["skill"]!}",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            user["location"]!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                user["description"]!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, color: Colors.white),
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Online",
                                                style: TextStyle(fontSize: 16, color: Colors.white70),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                Icons.circle,
                                                color: user["isOnline"] == "true" ? Colors.green : Colors.grey.shade400,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _animationController.forward(from: 0);
                                                  _handleDislike(index);
                                                },
                                                child: ScaleTransition(
                                                  scale: Tween<double>(begin: 1.0, end: 0.8).animate(
                                                    CurvedAnimation(
                                                      parent: _animationController,
                                                      curve: Curves.easeInOut,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.close, color: Colors.red, size: 32),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 48),
                                              GestureDetector(
                                                onTap: () {
                                                  _animationController.forward(from: 0);
                                                  _handleLike(
                                                    user["name"]!,
                                                    user["skill"]!,
                                                    user["image"]!,
                                                  );
                                                },
                                                child: ScaleTransition(
                                                  scale: Tween<double>(begin: 1.0, end: 0.8).animate(
                                                    CurvedAnimation(
                                                      parent: _animationController,
                                                      curve: Curves.easeInOut,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.teal.withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.favorite, color: Colors.teal, size: 32),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          icon: const FaIcon(FontAwesomeIcons.exclamation, color: Colors.red, size: 18),
                                          onPressed: () => _showReportDialog(user["name"]!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}