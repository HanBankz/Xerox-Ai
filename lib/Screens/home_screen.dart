import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';
import 'persona_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  // --- VARIABLES ZONE ---
  String _userName = '';
  String _displayedGreeting = '';
  String _fullGreeting = '';

  final List<Map<String, dynamic>> _tools = [
    {
      'title': 'AI Chat',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFFD2691E),
      'prompt': 'Your AI assistant. Answer questions clearly and concisely.',
    },
    {
      'title': 'Summarize',
      'icon': Icons.summarize_outlined,
      'color': Color(0xFF8B4513),
      'prompt': 'summarizes text concisely',
    },
    {
      'title': 'Write Email',
      'icon': Icons.email_outlined,
      'color': Color(0xFFD2691E),
      'prompt': 'writes professional emails',
    },
    {
      'title': 'Translate',
      'icon': Icons.translate,
      'color': Color(0xFF8B4513),
      'prompt': 'translates between languages',
    },
    {
      'title': 'Explain Code',
      'icon': Icons.code,
      'color': Color(0xFFD2691E),
      'prompt': 'explains and fixes code',
    },
    {
      'title': 'Brainstorm',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFF8B4513),
      'prompt': 'generates creative ideas',
    },
  ];

  // --- LIFECYCLE ZONE ---
  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // --- LOGIC ZONE ---
  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    setState(() {
      _userName = doc.data()?['name'] ?? 'there';
      _startTypingAnimation();
    });
  }

  void _startTypingAnimation() {
    _fullGreeting =
        '👋 Welcome back, $_userName! What are we working on today?';
    int index = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return false;
      setState(() {
        _displayedGreeting = _fullGreeting.substring(0, index + 1);
        index++;
      });
      return index < _fullGreeting.length;
    });
  }

  // --- UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              _displayedGreeting,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            title: tool['title']!,
                            systemPrompt: tool['prompt']!,
                          ),
                        ),
                      );
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

  // --- LOGIC ZONE ---
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  // --- UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1500),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PersonaSelectionScreen()),
              );
            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Xerox Ai',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF2C1500),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1A0A00)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    'Xerox AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2C1500),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD2691E),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
