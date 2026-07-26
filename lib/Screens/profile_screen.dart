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
  // --- VARIABLES ZONE ---
  String _name = '';
  String _email = '';
  bool _isLoading = true;

  // --- LIFECYCLE ZONE ---
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // --- LOGIC ZONE ---
  Future<void> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      setState(() {
        _name = doc.data()?['name'] ?? 'No name';
        _email = doc.data()?['email'] ?? 'No email';
        _isLoading = false;
      });
    }
  }

  //--UI ZONE--
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD2691E)),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF2C1500),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFFD2691E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TimesNewRoman',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 40),
const Divider(color: Color(0xFF2C1500), thickness: 1),
const SizedBox(height: 24),
ListTile(
  leading: const Icon(Icons.edit, color: Colors.red,
  ),
  onTap: () async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
  },
),
                  ],
                ),
              ),
            ),
    );
  }
}
