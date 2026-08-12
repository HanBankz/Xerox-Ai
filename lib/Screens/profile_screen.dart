import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // bankkz VARIABLES ZONE ---
  String _name = '';
  String _email = '';
  bool _isLoading = true;

  // --- LIFECYCLE ZONE ---
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // bankz LOGIC ZONE ---
  Future<void> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      _name = doc.data()?['name'] ?? '';
      _email = doc.data()?['email'] ?? '';
      _isLoading = false;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  // bankz UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1500),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF2C1500),
                    child: const Icon(Icons.person, size: 50, color: Color(0xFFD2691E)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _name,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C1500),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8B4513), width: 0.5),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit, color: Color(0xFFD2691E)),
                          title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {},
                        ),
                        const Divider(color: Color(0xFF8B4513), height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout', style: TextStyle(color: Colors.red)),
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}