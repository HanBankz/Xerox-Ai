import 'package:flutter/material.dart';
import 'persona_chat_screen.dart';

class PersonaSelectionScreen extends StatelessWidget {
  PersonaSelectionScreen({super.key});

  //variable zone
  final List<Map<String, dynamic>> _personas = [
    {
      'name': 'Programmer',
      'icon': Icons.code,
      'color': Colors.blue,
      'prompt': 'Your AI assistant. Answer questions clearly and concisely.',
      'greeting': 'In bankz we trust, What are we building today?',
      'hint': 'Describe your coding problem',
      'actions': [
        'Debug code',
        'optimize',
        'Explain',
        'Generate code',
        'Refactor',
        'Write Tests',
      ],
    },

    {
      'name': 'Tutor',
      'icon': Icons.school,
      'color': Colors.lightGreen,
      'prompt': 'generates creative ideas',
      'greeting': 'In bankz we trust, What would you like to learn today?',
      'hint': 'Ask me anything',
      'actions': [
        'Explain Concept',
        'Give Example',
        'Quiz Me',
        'Simplify',
        'Study Plan',
        'Summarize',
      ],
    },

    {
      'name': 'consultant',
      'icon': Icons.business_center,
      'color': Colors.yellow,
      'prompt': 'generates creative ideas',
      'greeting': 'In bankz we trust, How can I help your business today?',
      'hint': 'Describe your business challenge...',
      'actions': [
        'Business Plan',
        'SWOT Analysis',
        'Strategy',
        'Market Research',
        'Pitch Deck',
        'Financial Model',
      ],
    },

    {
      'name': 'writer',
      'icon': Icons.edit,
      'color': Colors.purple,
      'prompt':
          'You are a creative writing expert. Help with storytelling, essays, proposals and any written content.',
      'greeting': 'In bankz we trust, What are we writing today?',
      'hint': 'Describe what you want to write...',
      'actions': [
        'Write Email',
        'Write CV',
        'Blog Post',
        'Cover Letter',
        'Proposal',
        'Proofread',
      ],
    },

    {
      'name': 'Marketing Expert',
      'color': Colors.orange,
      'prompt':
          'You are a digital marketing strategist. Give actionable marketing advice focused on audience and growth.',
      'icon': Icons.trending_up,
      'greeting': 'In bankz we trust, Let\'s grow your audience today.',
      'hint': 'Describe your marketing challenge...',
      'actions': [
        'Content Ideas',
        'Ad Copy',
        'SEO Tips',
        'Social Media',
        'Email Campaign',
        'Brand Strategy',
      ],
    },

    {
      'name': 'Designer',
      'color': Colors.teal,
      'prompt':
          'You are a UI/UX design expert. Think about user experience, visual hierarchy and modern design principles.',
      'icon': Icons.palette,
      'greeting': 'In bankz we trust, What are we designing today?',
      'hint': 'Describe your design challenge...',
      'actions': [
        'UI Review',
        'Color Palette',
        'Typography',
        'User Flow',
        'Wireframe',
        'Design System',
      ],
    },
  ];

  Widget _buildPersonaCard(int index, BuildContext context) {
    final persona = _personas[index];
    return GestureDetector(
      onTap: () {
        print(
          'Tapping: ${persona['name']}, color: ${persona['color']}, prompt: ${persona['prompt']}',
        );
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
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(persona['icon'], color: persona['color'] as Color, size: 40),
            const SizedBox(height: 12),
            Text(
              persona['name'],
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
          'Choose Your AI Persona',
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
