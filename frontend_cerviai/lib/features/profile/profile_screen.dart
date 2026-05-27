import 'package:flutter/material.dart';
import '../../main.dart'; // Import to access themeNotifier

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              "Dr. Sophia Carter",
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "Oncologist",
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            // Settings List
            _buildProfileItem(context, icon: Icons.person_outline, title: "Edit Profile"),
            _buildProfileItem(context, icon: Icons.notifications_outlined, title: "Notifications"),
            
            // Theme Toggle
            ValueListenableBuilder<ThemeMode>(
              valueListenable: CervicAIApp.themeNotifier,
              builder: (context, currentMode, _) {
                 bool isDark = currentMode == ThemeMode.dark;
                 return ListTile(
                   leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.brightness_6, color: theme.colorScheme.primary),
                  ),
                  title: const Text("Dark Mode"),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) {
                      CervicAIApp.themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                 );
              },
            ),

            _buildProfileItem(context, icon: Icons.help_outline, title: "Help & Support"),
            _buildProfileItem(context, icon: Icons.info_outline, title: "About App"),
            
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Logout", 
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, {required IconData icon, required String title}) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFE91E63), // Default medicalPink
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
