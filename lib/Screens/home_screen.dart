import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class HomeContent extends StatelessWidget {
  HomeContent({super.key});
  final List<Map<String, dynamic>> _tools = [
    {
      'title': 'AI Chat',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFFD2691E),
    },
    {
      'title': 'Summarize',
      'icon': Icons.summarize_outlined,
      'color': Color(0xFF8B4513),
    },
    {
      'title': 'Write Email',
      'icon': Icons.email_outlined,
      'color': Color(0xFFD2691E),
    },
    {'title': 'Translate', 'icon': Icons.translate, 'color': Color(0xFF8B4513)},
    {'title': 'Explain Code', 'icon': Icons.code, 'color': Color(0xFFD2691E)},
    {
      'title': 'Brainstorm',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFF8B4513),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'What would you like to do?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _tools.length,
                itemBuilder: (context, index) {
                  final tool = _tools[index];
                  return GestureDetector(
                    onTap: () {
                      print('${tool['title']} tapped');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C1500),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: tool['color'], width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: tool['color'].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(tool['icon'], color: tool['color'], size: 36),
                          const SizedBox(height: 12),
                          Text(
                            tool['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // --- VARIABLES ZONE ---
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeContent(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];
  final List<Map<String, dynamic>> _tools = [
    {
      'title': 'AI Chat',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFFD2691E),
    },
    {
      'title': 'Summarize',
      'icon': Icons.summarize_outlined,
      'color': Color(0xFF8B4513),
    },
    {
      'title': 'Write Email',
      'icon': Icons.email_outlined,
      'color': Color(0xFFD2691E),
    },
    {'title': 'Translate', 'icon': Icons.translate, 'color': Color(0xFF8B4513)},
    {'title': 'Explain Code', 'icon': Icons.code, 'color': Color(0xFFD2691E)},
    {
      'title': 'Brainstorm',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFF8B4513),
    },
  ];

  Widget _buildToolCard(int index) {
    final tool = _tools[index];
    return GestureDetector(
      onTap: () {
        print('${tool['title']} tapped');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C1500),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tool['color'], width: 1.5),
          boxShadow: [
            BoxShadow(
              color: tool['color'].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tool['icon'], color: tool['color'], size: 36),
            const SizedBox(height: 12),
            Text(
              tool['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC ZONE ---
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  //buildtoolcard---

  //---UI zone---
  // --- UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1500),
        title: const Text(
          'Xerox Ai',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2C1500),
        selectedItemColor: const Color(0xFFD2691E),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        //bottom navigation--
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
