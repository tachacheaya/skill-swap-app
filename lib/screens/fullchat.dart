import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class FullChatPage extends StatelessWidget {
  const FullChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFF0F6); // Fond doux rose clair

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "My Chats",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD67FEF),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/chat_icon.png', height: 60),
                ],
              ),
            ),

            // Chat list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ChatTile(
                    name: "Sarah Chadli",
                    status: "Online 20 min ago",
                    imagePath: "assets/images/pic2.jpg",
                    isOnline: false,
                  ),
                  ChatTile(
                    name: "Mohamed MN",
                    status: "Online",
                    imagePath: "assets/images/pic.jpg",
                    isOnline: true,
                  ),
                  ChatTile(
                    name: "Fella Ahmedkhoudja",
                    status: "Online 1h ago",
                    imagePath: "assets/images/pic3.jpg",
                    isOnline: false,
                  ),
                  ChatTile(
                    name: "Aymen BK",
                    status: "Online 1h ago",
                    imagePath: "assets/images/pic5.jpg",
                    isOnline: false,
                  ),
                  ChatTile(
                    name: "Aya Tachache",
                    status: "Online 54 min ago",
                    imagePath: "assets/images/pic7.jpg",
                    isOnline: false,
                  ),
                ],
              ),
            ),

            // Bottom logo
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Image.asset('assets/images/puzzle_logo.png', height: 50),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String status;
  final String imagePath;
  final bool isOnline;

  const ChatTile({
    super.key,
    required this.name,
    required this.status,
    required this.imagePath,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFFFBE8FF); // Couleur rose douce
    const nameColor = Colors.black87;
    const statusColor = Color(0xFF9C27B0); // Violet foncé
    const onlineBadgeColor = Colors.green;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(
              userName: name,
              imagePath: imagePath,
              status: status,
            ),
          ),
        );
      },
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      imagePath,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: onlineBadgeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: nameColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.deepPurple, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
