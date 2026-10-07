import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> skillsExchange = [];
  List<String> skillsToLearn = [];
  List<File> profileImages = [];
  final picker = ImagePicker();

  final List<String> allSkills = [
    'Programming',
    'Cooking',
    'Photography',
    'Design',
    'Languages',
    'Marketing',
    'Writing',
    'Painting',
    'Mobile Development'
  ];

  final user = FirebaseAuth.instance.currentUser;
  final dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    profileImages.add(File('assets/images/pic.png'));
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (user == null) return;
    final snapshot = await dbRef.child('users/${user!.uid}/profile').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        fullNameController.text = data['fullName'] ?? '';
        descriptionController.text = data['description'] ?? '';
        skillsExchange = List<String>.from(data['skillsExchange'] ?? []);
        skillsToLearn = List<String>.from(data['skillsToLearn'] ?? []);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (user == null) return;
    await dbRef.child('users/${user!.uid}/profile').set({
      'fullName': fullNameController.text.trim(),
      'description': descriptionController.text.trim(),
      'skillsExchange': skillsExchange,
      'skillsToLearn': skillsToLearn,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved")),
    );
  }

  Future<void> _addProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImages.add(File(pickedFile.path));
      });
    }
  }

  void _deleteProfileImage() {
    if (profileImages.length > 1) {
      setState(() {
        profileImages.removeLast();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one photo must remain.')),
      );
    }
  }

  void _viewAllPhotos() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "My Photos",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B4B9B),
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: profileImages.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(profileImages[index], width: 140, height: 160, fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B4B9B),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  void _editSkills(List<String> targetList, String title, Function(List<String>) onUpdate) {
    List<String> selected = [...targetList];
    String newSkill = '';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4B9B),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  children: allSkills.map((skill) {
                    final isSelected = selected.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: isSelected,
                      selectedColor: const Color(0xFFB97BEB).withOpacity(0.3),
                      checkmarkColor: const Color(0xFF6B4B9B),
                      onSelected: (bool value) {
                        setModalState(() {
                          if (value) {
                            selected.add(skill);
                          } else {
                            selected.remove(skill);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Add a skill",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (val) => newSkill = val,
                  onSubmitted: (_) {
                    if (newSkill.trim().isNotEmpty && !selected.contains(newSkill.trim())) {
                      setModalState(() {
                        selected.add(newSkill.trim());
                        newSkill = '';
                      });
                    }
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF6B4B9B)),
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4B9B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                onUpdate(selected);
                Navigator.pop(context);
              },
              child: const Text("Validate"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSkillBox(String title, List<String> skills, Color bgColor, Color iconColor, Function() onEdit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF6B4B9B),
            )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              skills.isEmpty
                  ? Text(
                      'No skills added yet',
                      style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                    )
                  : Wrap(
                      spacing: 10.0,
                      runSpacing: 8.0,
                      children: skills.map((skill) {
                        return Chip(
                          label: Text(skill),
                          backgroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.black26,
                          deleteIconColor: iconColor,
                          onDeleted: () {
                            setState(() {
                              skills.remove(skill);
                            });
                          },
                        );
                      }).toList(),
                    ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.edit, color: iconColor, size: 28),
                  onPressed: onEdit,
                  tooltip: 'Edit $title',
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = profileImages.isNotEmpty;
    final themeColor = const Color(0xFF6B4B9B);
    final exchangeBoxColor = const Color(0xFFF5E6FF);
    final learnBoxColor = const Color(0xFFEDE6F9);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 58,
                backgroundColor: themeColor.withOpacity(0.3),
                backgroundImage: hasImage ? FileImage(profileImages.last) : null,
                child: !hasImage
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: themeColor.withOpacity(0.7),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: 'Delete last photo',
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.redAccent.withOpacity(0.15),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: _deleteProfileImage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Tooltip(
                    message: 'View all photos',
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: themeColor.withOpacity(0.15),
                      child: IconButton(
                        icon: const Icon(Icons.photo_library, color: Color(0xFF6B4B9B)),
                        onPressed: _viewAllPhotos,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Tooltip(
                    message: 'Add new photo',
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.green.withOpacity(0.15),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: _addProfileImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Full Name",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: fullNameController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your full name...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Describe yourself...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 28),

              buildSkillBox(
                "Skills I'm exchanging",
                skillsExchange,
                exchangeBoxColor,
                themeColor,
                () => _editSkills(skillsExchange, "Edit Skills I'm exchanging", (updated) {
                  setState(() => skillsExchange = updated);
                }),
              ),

              const SizedBox(height: 28),

              buildSkillBox(
                "Skills I want to learn",
                skillsToLearn,
                learnBoxColor,
                themeColor,
                () => _editSkills(skillsToLearn, "Edit Skills I want to learn", (updated) {
                  setState(() => skillsToLearn = updated);
                }),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
  onPressed: _saveProfile,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF7A52D8), // violet foncé
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  child: const Text(
    "Save",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
  ),
),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
