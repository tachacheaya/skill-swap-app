import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillswapproj/screens/login_screen.dart';
import 'manage_users_page.dart';
import 'manage_reports_page.dart';
import 'login_screen.dart'; // Assumes LoginPage exists

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEDE9FE), // Pastel purple
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Confirm Logout',
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B3A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B3A7A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: const Color(0xFF4B3A7A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFCA5A5), // Soft red for emphasis
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildAdminTile(
          icon: Icons.person,
          title: 'Manage Users',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUsersPage()));
          },
        ),
        const SizedBox(height: 20),
        _buildAdminTile(
          icon: Icons.report,
          title: 'Manage Reports',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ManageReportsPage()));
          },
        ),
      ],
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2F6), // Pastel pink background
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B3A7A),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFD8B4FE), // Light purple
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF4B3A7A),
            ),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: listView,
    );
  }

  Widget _buildAdminTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      tileColor: const Color(0xFFEDE9FE), // Pastel purple
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: Icon(icon, size: 35, color: const Color(0xFF4B3A7A)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4B3A7A),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF4B3A7A)),
      onTap: onTap,
    );
  }
}