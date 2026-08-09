// ignore_for_file: dot_shorthand_everywhere
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AiService {
  Future<String> sendMessage(
    List<Map<String, String>> messages,
    String systemPrompt,
  ) async {
    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final body = jsonEncode({
      'model': 'llama-3.3-70b-versatile',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages.map((m) => {'role': m['role'], 'content': m['content']}),
      ],
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $groqApiKey',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print('Groq error: ${response.body}');
      throw Exception('AI error: ${response.statusCode}');
    }
  }

  Future<void> saveChat(
    String title,
    List<Map<String, String>> messages,
  ) async {
    print('saveChat called for: $title');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .add({
          'title': title,
          'messages': messages,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
}
