import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String imagePath;
  final String status;

  const ChatDetailPage({
    Key? key,
    required this.userName,
    required this.imagePath,
    required this.status,
  }) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  List<String> messages = [
    "Hey! I saw you offer guitar lessons 🎸",
    "Yes, I'd be happy to help 😄",
    "Awesome! When are you available?",
    "Wednesday and Friday afternoons work for me.",
    "Friday at 3 PM?",
    "Perfect! I'll send you the Meet link.",
    "Looking forward to it 🙌",
  ];

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(text);
        _messageController.clear();
      });
    }
  }

  void _showDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 14, minute: 0),
      );

      if (selectedTime != null) {
        final fullDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final formatted = DateFormat('dd/MM/yyyy – HH:mm').format(fullDateTime);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meeting scheduled for $formatted')),
        );
      }
    }
  }

  void _launchGoogleMeet() async {
    final Uri meetUrl = Uri.parse('https://meet.google.com/new');

    if (!await launchUrl(meetUrl, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open Google Meet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color pink = Color(0xFFD67FEF);
    const Color lightPink = Color(0xFFFCE4EC);
    const Color background = Color(0xFFFFF0F6);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: pink,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.imagePath),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white)),
                Text(widget.status,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white70)),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
            onPressed: _launchGoogleMeet,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: _showDateTimePicker,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? pink : lightPink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      messages[index],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Write a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: pink),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
