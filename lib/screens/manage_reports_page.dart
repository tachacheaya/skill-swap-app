import 'package:flutter/material.dart';

class ManageReportsPage extends StatelessWidget {
  ManageReportsPage({super.key});

  final List<Map<String, String>> reports = [
    {
      'reporter': 'Aya',
      'reportedUser': 'Fella',
      'reason': 'Spam',
    },
    {
      'reporter': 'Sarah',
      'reportedUser': 'Aymen',
      'reason': 'Inappropriate content',
    },
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reports'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: Text('${report['reporter']} reported ${report['reportedUser']}'),
              subtitle: Text('Reason: ${report['reason']}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 204, 132, 216)),
                child: const Text('Review'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Review report of ${report['reportedUser']}')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


