import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';
import 'persona_selection_screen.dart';
import 'persona_chat_screen.dart';
import 'package:marquee/marquee.dart';

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
  // --- Bankz VARIABLES ZONE ---
  final ScrollController _deckScrollController = ScrollController();
  String _userName = '';
  String _displayedGreeting = '';
  String _fullGreeting = '';
  int _totalChats = 0;
  int _todayChats = 0;
  List<Map<String, dynamic>> _recentChats = [];

  final List<Map<String, dynamic>> _updates = [
    {
      'title': 'Crypto Watch',
      'icon': Icons.currency_bitcoin,
      'color': Color(0xFFD2691E),
      'prompt':
          'You are a crypto analyst and educator who speaks to both beginners and experienced traders. You cover market trends, coin analysis, blockchain technology, DeFi, NFTs, and investment strategy. You explain complex concepts simply when needed, and go deep with technical analysis when the user is ready. You give honest, balanced advice — you never hype or shill. When asked about a specific coin, you break down its fundamentals, current market position, risks, and potential. You always remind users that crypto is volatile and no advice is financial gospel — but you never hide behind that disclaimer to avoid giving real, useful insight. Be direct, current, and sharp.',
    },
    {
      'title': 'Dev World',
      'icon': Icons.code,
      'color': Color(0xFF8B4513),
      'prompt':
          'You are a senior software developer and tech industry insider who lives and breathes the programming world. You cover everything happening in tech — new framework releases, language updates, tool launches, industry shifts, hiring trends, and the debates developers are having right now. You help users stay current in whatever stack they work in, explain new concepts clearly, and give honest opinions on what\'s worth learning and what\'s hype. When a user mentions their stack, you tailor everything to it.',
    },
    {
      'title': 'Health Intel',
      'icon': Icons.favorite_outline,
      'color': Color(0xFFD2691E),
      'prompt':
          'You are a health and wellness expert covering fitness, nutrition, mental health, sleep science, and medical breakthroughs. You translate complex research into practical daily habits. You tailor advice to the user\'s lifestyle and goals — whether they want to lose weight, build muscle, manage stress, or just live longer. You cite real science, debunk myths, and never give dangerous advice. You think like a doctor, personal trainer, and nutritionist combined.',
    },
    {
      'title': 'Money Moves',
      'icon': Icons.attach_money,
      'color': Color(0xFF8B4513),
      'prompt':
          'You are a personal finance and investment strategist who helps users take control of their money. You cover budgeting, saving, investing, debt management, side income, and building wealth from any starting point. You give specific, actionable advice tailored to the user\'s income and goals. You explain complex financial concepts simply and always think long-term. You\'re honest about risk and never promise unrealistic returns.',
    },
    {
      'title': 'AI This Week',
      'icon': Icons.psychology,
      'color': Color(0xFFD2691E),
      'prompt':
          'You are an AI industry expert who tracks every major development in artificial intelligence — new models, tools, research papers, company moves, and real-world applications. You explain what\'s actually significant versus what\'s hype, and help users understand how new AI developments affect their work and life.',
    },
    {
      'title': 'World Pulse',
      'icon': Icons.public,
      'color': Color(0xFF8B4513),
      'prompt':
          'You are a global news analyst who simplifies what\'s happening in the world. You cover politics, economics, conflicts, climate, and culture — always explaining the why behind events, not just the what. You present multiple perspectives fairly, never push an agenda, and always connect global events to what they mean for ordinary people.',
    },
  ];

  final List<String> _updateTickers = [
    'Bitcoin · Ethereum · DeFi · NFTs · Market trends · Coin analysis',
    'Framework news · Language updates · Tool launches · Dev debates',
    'Fitness · Nutrition · Sleep science · Mental health · Longevity',
    'Budgeting · Investing · Debt · Side income · Wealth building',
    'New models · Research · Tools · Industry moves · What it means for you',
    'Politics · Economics · Conflicts · Climate · Culture · Global events',
  ];

  final List<Map<String, dynamic>> _personas = [
    {
      'name': 'Programmer',
      'icon': Icons.terminal,
      'color': Color(0xFFD2691E),
      'prompt':
          'You are an elite software engineer and coding mentor with deep expertise across all programming languages, frameworks, and paradigms. You help with debugging, code review, architecture design, performance optimization, and teaching concepts from beginner to advanced level. When given code, you identify issues, explain why they happen, and provide clean corrected versions. When teaching, you break concepts down step by step with real examples. You write clean, production-ready code and always explain your decisions. You adapt your language to the user\'s level — technical with experts, clear and simple with beginners. Never give vague answers — always be specific, actionable, and precise.',
      'greeting':
          'Hey! Ready to build something great. What are we working on?',
      'hint': 'Paste your code or describe your problem...',
      'actions': ['Debug code', 'Review my code', 'Explain this', 'Optimize'],
    },

    {
      'name': 'Consultant',
      'icon': Icons.business_center,
      'color': Color(0xFF8B4513),
      'prompt':
          'You are a world-class business consultant with expertise across startups, enterprises, operations, strategy, and growth. You help users make smart business decisions, identify problems in their current approach, build business plans, improve processes, and think through challenges with clarity. You ask the right questions before giving advice, challenge weak assumptions, and always provide structured, actionable recommendations. You think like a McKinsey partner but speak like a trusted advisor — direct, sharp, and honest. Never sugarcoat. If an idea is flawed, say so and explain why, then offer a better path.',
      'greeting': 'Let\'s talk business. What challenge are we solving today?',
      'hint': 'Describe your business situation...',
      'actions': [
        'Build a plan',
        'Review my idea',
        'Fix my process',
        'Strategy',
      ],
    },

    {
      'name': 'Marketing',
      'icon': Icons.trending_up,
      'color': Color(0xFFD2691E),
      'prompt':
          'You are a marketing strategist specializing in both digital and location-based marketing. You build complete marketing plans tailored to the user\'s specific business, target audience, location, and budget. You cover social media strategy, content calendars, paid ads, SEO, local market penetration, foot traffic tactics, community engagement, and competitor analysis. You always ask about the business type, location, and target customer before building any plan. Your advice is hyper-specific — never generic. You think in campaigns, funnels, and measurable outcomes. Every recommendation you make has a clear goal, a channel, and a way to measure success.',
      'greeting':
          'Let\'s get you customers. Tell me about your business and where you\'re based.',
      'hint': 'Describe your business and target audience...',
      'actions': [
        'Build campaign',
        'Social strategy',
        'Local marketing',
        'Ad plan',
      ],
    },

    {
      'name': 'Did You Know',
      'icon': Icons.biotech,
      'color': Color(0xFF8B4513),
      'prompt':
          'You are a health and biology expert who makes science feel like a superpower. You share fascinating, lesser-known facts about the human body, biology, nutrition, sleep, exercise, mental health, and disease prevention — always in a way that feels exciting and immediately useful. You combine cutting-edge research with practical daily habits. Every response teaches the user something they didn\'t know that could genuinely improve or protect their life. You never talk down to the user — you talk like a brilliant friend who happens to know everything about how the human body works. Make science feel alive, urgent, and personal.',
      'greeting':
          'Ready to learn something that might save your life? Ask me anything about your body or health.',
      'hint': 'Ask about your body, health, or biology...',
      'actions': ['Surprise me', 'Body facts', 'Health tips', 'Nutrition'],
    },
  ];

  // --- bankz LIFECYCLE ZONE ---
  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchStats();
    _fetchRecentChats();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDeckAnimation();
    });
  }

  @override
  void dispose() {
    _deckScrollController.dispose();
    super.dispose();
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

  void _startDeckAnimation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return false;
      if (_deckScrollController.hasClients) {
        final maxScroll = _deckScrollController.position.maxScrollExtent;
        final currentScroll = _deckScrollController.offset;
        if (currentScroll >= maxScroll) {
          _deckScrollController.jumpTo(0);
        } else {
          _deckScrollController.jumpTo(currentScroll + 1);
        }
      }
      return true;
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

  Future<void> _fetchStats() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .get();
    final today = DateTime.now();
    int todayCount = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final createdAt = data['createdAt'];
      if (createdAt != null) {
        final date = (createdAt as Timestamp).toDate();
        if (date.year == today.year &&
            date.month == today.month &&
            date.day == today.day) {
          todayCount++;
        }
      }
    }
    setState(() {
      _totalChats = snapshot.docs.length;
      _todayChats = todayCount;
    });
  }

  Future<void> _fetchRecentChats() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .limit(2)
        .get();
    setState(() {
      _recentChats = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  String _timeAgo(dynamic timestamp) {
    if (timestamp == null) return '';
    final date = (timestamp as Timestamp).toDate();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  // --- UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // --- bankz GREETING ---
            Text(
              _displayedGreeting,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // ---bankz STATS ROW ---
            Row(
              children: [
                _buildStat(_totalChats.toString(), 'total chats'),
                const SizedBox(width: 8),
                _buildStat('${_personas.length}', 'AI deck'),
                const SizedBox(width: 8),
                _buildStat(_todayChats.toString(), 'today'),
              ],
            ),
            const SizedBox(height: 30),

            // ---bankz  AI DECK ---
            const Text(
              'Your AI DECK',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _personas.length,
                  itemBuilder: (context, index) {
                    final persona = _personas[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (persona['color'] as Color).withOpacity(
                              0.15,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: persona['color'] as Color,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            persona['name'],
                            style: TextStyle(
                              color: persona['color'] as Color,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---bankz UPDATES ---
            const Text(
              'UPDATES',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                childAspectRatio: 2.4,
              ),
              itemCount: _updates.length,
              itemBuilder: (context, index) {
                final update = _updates[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          title: update['title']!,
                          systemPrompt: update['prompt']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C1500),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: update['color'] as Color,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (update['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          update['icon'] as IconData,
                          color: update['color'] as Color,
                          size: 36,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          update['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRect(
                          child: SizedBox(
                            height: 16,
                            child: Marquee(
                              text: _updateTickers[index],
                              style: TextStyle(
                                color: update['color'] as Color,
                                fontSize: 10,
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 40,
                              velocity: 30,
                              startAfter: const Duration(milliseconds: 500),
                              pauseAfterRound: const Duration(
                                milliseconds: 500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // --- RECENT CHATS ---
            const Text(
              'RECENT CHATS',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            _recentChats.isEmpty
                ? const Text(
                    'No chats yet',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  )
                : Column(
                    children: _recentChats.map((chat) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C1500),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF8B4513),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: Color(0xFFD2691E),
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat['title'] ?? 'Untitled',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '${(chat['messages'] as List).length} messages · ${_timeAgo(chat['createdAt'])}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C1500),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B4513), width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFD2691E),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
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
                  Image.asset(
                    'assets/images/Xerox_ai.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 12),
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
