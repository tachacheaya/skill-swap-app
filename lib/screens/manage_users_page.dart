import 'package:flutter/material.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  // Liste simulée des utilisateurs avec un identifiant, un nom, un email et un état de blocage
  List<Map<String, dynamic>> users = [
    {'userId': '1', 'fullName': 'Aya', 'email': 'ayatachache@gmail.com', 'isBlocked': false},
    {'userId': '2', 'fullName': 'Sarah ', 'email': 'sarahchadli@gmail.com', 'isBlocked': false},
    {'userId': '3', 'fullName': 'Mohamed', 'email': 'mohamed@gmail.com', 'isBlocked': false},
     {'userId': '4', 'fullName': 'fella', 'email': 'fellahmedkhoudja@gmail.com', 'isBlocked': false},
      {'userId': '5', 'fullName': 'aymen', 'email': 'Aymen@gmail.com', 'isBlocked': false},
       {'userId': '6', 'fullName': 'arwa', 'email': 'arwa@gmail.com', 'isBlocked': false},
  ];

  // Liste des utilisateurs bloqués
  Map<String, bool> blockedUsers = {};

  // Simuler la suppression d'un utilisateur (localement)
  void _deleteUser(String userId) async {
    try {
      setState(() {
        users.removeWhere((user) => user['userId'] == userId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  // Simuler le blocage d'un utilisateur (localement)
  void _blockUser(String userId) {
    setState(() {
      // Trouver l'utilisateur et mettre à jour l'état de blocage
      final userIndex = users.indexWhere((user) => user['userId'] == userId);
      if (userIndex != -1) {
        users[userIndex]['isBlocked'] = true;
        blockedUsers[userId] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User blocked')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final userId = user['userId'];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(user['fullName'] ?? 'No Name'),
              subtitle: user['isBlocked'] == true
                  ? const Text('Blocked', style: TextStyle(color: Colors.red))
                  : Text(user['email'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.block, color: Colors.orange),
                    onPressed: user['isBlocked'] == true
                        ? null
                        : () => _blockUser(userId), // Désactiver le blocage si déjà bloqué
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(userId),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}