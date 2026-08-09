import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // --- VARIABLES ZONE ---
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  // --- LIFECYCLE ZONE ---
  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchChats();
  }

  // --- LOGIC ZONE ---
  Future<void> _fetchChats() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .get();
      setState(() {
        _chats = snapshot.docs.map((doc) => doc.data()).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  // --- UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C1500),
        title: const Text('History', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chats.isEmpty
          ? const Center(
              child: Text(
                'No chats yet',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return ListTile(
                  title: Text(
                    chat['title'] ?? 'Untitled',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${(chat['messages'] as List).length} messages',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFFD2691E),
                  ),
                );
              },
            ),
    );
  }
}
