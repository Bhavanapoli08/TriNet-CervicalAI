import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../reports/reports_screen.dart';
import '../../core/widgets/feature_card.dart';
import '../upload/upload_screen.dart';
import '../doctor_consultation/doctor_consultation_screen.dart';
import '../foods_nutrition/foods_nutrition_screen.dart';
import '../cancer_info/cancer_info_screen.dart';

import '../chatbot/chatbot_screen.dart';
import '../../services/chat_service.dart';
import '../../services/api_keys.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(),
    const DoctorConsultationScreen(),
    const FoodsNutritionScreen(),
    const CancerInfoScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("CervicAI - Your Health Companion"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              accountName: const Text("Patient Profile"),
              accountEmail: const Text("patient@health.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text("My Reports"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety_outlined),
              title: const Text("Consult Doctor"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            // ===== NEW: Drawer entry for the AI Chatbot =====
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text("Ask CerviAI"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatbotScreen(
                      chatService: ChatService(apiKey: ApiKeys.openAi),
                    ),
                  ),
                );
              },
            ),
            // ===============================================
            ListTile(
              leading: const Icon(Icons.restaurant_outlined),
              title: const Text("Foods & Nutrition"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text("Cancer Info & News"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: const Text("My Profile"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 4);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      // ===== NEW: Floating Action Button for one-tap chatbot access =====
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatbotScreen(
                chatService: ChatService(apiKey: ApiKeys.openAi),
              ),
            ),
          );
        },
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text("Ask CerviAI"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      )
          : null,
      // =================================================================
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety),
            label: 'Doctor',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Foods',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outlined),
            selectedIcon: Icon(Icons.info),
            label: 'Info',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        // Welcome Header
        Text(
          "Welcome Back,",
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          "Your Health Journey",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),

        // Health Status Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Latest Report",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "No abnormalities detected. Keep following healthy practices!",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Quick Actions Label
        Text(
          "What Would You Like To Do?",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Feature Cards
        FeatureCard(
          title: "Get Tested",
          description: "Upload your screening sample for AI analysis.",
          icon: Icons.upload_file_outlined,
          color: theme.colorScheme.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadScreen()),
            );
          },
        ),
        FeatureCard(
          title: "View Reports",
          description: "See your screening history, risk summary and warning signs.",
          icon: Icons.article_outlined,
          color: theme.colorScheme.secondary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsScreen()),
            );
          },
        ),
        FeatureCard(
          title: "Consult a Doctor",
          description: "Chat with our medical professionals online.",
          icon: Icons.health_and_safety_outlined,
          color: theme.colorScheme.secondary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorConsultationScreen()),
            );
          },
        ),
        // ===== NEW: AI Chatbot Feature Card =====
        FeatureCard(
          title: "Ask CerviAI",
          description: "Chat with our AI assistant about cervical health, Pap smears, HPV, and more.",
          icon: Icons.smart_toy_outlined,
          color: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatbotScreen(
                  chatService: ChatService(apiKey: ApiKeys.openAi),
                ),
              ),
            );
          },
        ),
        // ========================================
        FeatureCard(
          title: "Healthy Foods",
          description: "Learn about foods that support your health.",
          icon: Icons.restaurant_outlined,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodsNutritionScreen()),
            );
          },
        ),
        FeatureCard(
          title: "Cancer Info & News",
          description: "Stay informed about cervical cancer prevention.",
          icon: Icons.info_outlined,
          color: theme.colorScheme.tertiary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CancerInfoScreen()),
            );
          },
        ),
      ],
    );
  }
}