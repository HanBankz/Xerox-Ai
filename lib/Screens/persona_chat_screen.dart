import 'package:flutter/material.dart';

class PersonaChatScreen extends StatefulWidget {
  final String name;
final String systemPrompt;
final Color accentColor;
final String greeting;
final String hint;
final List actions;

  const PersonaChatScreen({super.key, required this.name, required this.systemPrompt, required this.accentColor, required this.greeting, required this.hint, required this.actions});

  @override
  State<PersonaChatScreen> createState() => _PersonaChatScreenState();
}

class _PersonaChatScreenState extends State<PersonaChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}