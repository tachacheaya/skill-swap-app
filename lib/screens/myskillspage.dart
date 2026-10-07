import 'package:flutter/material.dart';

class MySkillsPage extends StatefulWidget {
  const MySkillsPage({Key? key}) : super(key: key);

  @override
  State<MySkillsPage> createState() => _MySkillsPageState();
}

class _MySkillsPageState extends State<MySkillsPage> {
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

  final Set<String> selectedSkills = {};

  void toggleSkill(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
  }

  void saveSkills() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Skills saved: ${selectedSkills.join(', ')}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFB97BEB),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Skills'),
        backgroundColor: const Color(0xFFB97BEB),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: allSkills.length,
              itemBuilder: (context, index) {
                final skill = allSkills[index];
                final isSelected = selectedSkills.contains(skill);

                return Card(
                  color: isSelected ? Colors.pink[200] : Colors.pink[50],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      skill,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Color(0xFF4B3BB8),
                      ),
                    ),
                    value: isSelected,
                    onChanged: (bool? value) => toggleSkill(skill),
                    activeColor: const Color(0xFFB97BEB),
                    checkColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB97BEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: saveSkills,
              child: const Text(
                'Save Skills',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
