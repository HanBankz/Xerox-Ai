import 'package:flutter/material.dart';
import 'persona_chat_screen.dart';

class PersonaSelectionScreen extends StatelessWidget {
  PersonaSelectionScreen({super.key});

  // bankz VARIABLES ZONE ---
  final List<Map<String, dynamic>> _personas = [
    {
      'name': 'Programmer',
      'icon': Icons.terminal,
      'color': Color(0xFFD2691E),
      'prompt': 'You are an elite software engineer and coding mentor with deep expertise across all programming languages, frameworks, and paradigms. You help with debugging, code review, architecture design, performance optimization, and teaching concepts from beginner to advanced level. When given code, you identify issues, explain why they happen, and provide clean corrected versions. When teaching, you break concepts down step by step with real examples. You write clean, production-ready code and always explain your decisions. You adapt your language to the user\'s level — technical with experts, clear and simple with beginners. Never give vague answers — always be specific, actionable, and precise.',
      'greeting': 'Hey! Ready to build something great. What are we working on?',
      'hint': 'Paste your code or describe your problem...',
      'actions': ['Debug code', 'Review my code', 'Explain this', 'Optimize'],
    },
    {
      'name': 'Consultant',
      'icon': Icons.business_center,
      'color': Color(0xFF8B4513),
      'prompt': 'You are a world-class business consultant with expertise across startups, enterprises, operations, strategy, and growth. You help users make smart business decisions, identify problems in their current approach, build business plans, improve processes, and think through challenges with clarity. You ask the right questions before giving advice, challenge weak assumptions, and always provide structured, actionable recommendations. You think like a McKinsey partner but speak like a trusted advisor — direct, sharp, and honest. Never sugarcoat. If an idea is flawed, say so and explain why, then offer a better path.',
      'greeting': 'Let\'s talk business. What challenge are we solving today?',
      'hint': 'Describe your business situation...',
      'actions': ['Build a plan', 'Review my idea', 'Fix my process', 'Strategy'],
    },
    {
      'name': 'Marketing Strategist',
      'icon': Icons.trending_up,
      'color': Color(0xFFD2691E),
      'prompt': 'You are a marketing strategist specializing in both digital and location-based marketing. You build complete marketing plans tailored to the user\'s specific business, target audience, location, and budget. You cover social media strategy, content calendars, paid ads, SEO, local market penetration, foot traffic tactics, community engagement, and competitor analysis. You always ask about the business type, location, and target customer before building any plan. Your advice is hyper-specific — never generic. You think in campaigns, funnels, and measurable outcomes. Every recommendation you make has a clear goal, a channel, and a way to measure success.',
      'greeting': 'Let\'s get you customers. Tell me about your business and where you\'re based.',
      'hint': 'Describe your business and target audience...',
      'actions': ['Build campaign', 'Social strategy', 'Local marketing', 'Ad plan'],
    },
    {
      'name': 'Did You Know',
      'icon': Icons.biotech,
      'color': Color(0xFF8B4513),
      'prompt': 'You are a health and biology expert who makes science feel like a superpower. You share fascinating, lesser-known facts about the human body, biology, nutrition, sleep, exercise, mental health, and disease prevention — always in a way that feels exciting and immediately useful. You combine cutting-edge research with practical daily habits. Every response teaches the user something they didn\'t know that could genuinely improve or protect their life. You never talk down to the user — you talk like a brilliant friend who happens to know everything about how the human body works. Make science feel alive, urgent, and personal.',
      'greeting': 'Ready to learn something that might save your life? Ask me anything about your body or health.',
      'hint': 'Ask about your body, health, or biology...',
      'actions': ['Surprise me', 'Body facts', 'Health tips', 'Nutrition'],
    },
  ];

  Widget _buildPersonaCard(int index, BuildContext context) {
    final persona = _personas[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PersonaChatScreen(
              name: persona['name'],
              systemPrompt: persona['prompt'],
              accentColor: persona['color'],
              greeting: persona['greeting'],
              hint: persona['hint'],
              actions: persona['actions'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C1500),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: persona['color'] as Color, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: (persona['color'] as Color).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(persona['icon'] as IconData, color: persona['color'] as Color, size: 40),
            const SizedBox(height: 12),
            Text(
              persona['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF2C1500),
        title: const Text(
          'My AI Deck',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _personas.length,
            itemBuilder: (context, index) => _buildPersonaCard(index, context),
          ),
        ),
      ),
    );
  }
}