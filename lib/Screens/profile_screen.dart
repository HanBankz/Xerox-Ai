import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      body: const Center(
        child: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
