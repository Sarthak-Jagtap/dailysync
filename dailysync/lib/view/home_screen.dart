import 'package:dailysync/view/dashboard.dart';
import 'package:dailysync/view/health_main.dart';

import 'package:dailysync/providers/theme_provider.dart';
import 'package:dailysync/view/todo_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_screen.dart';


class HomeDashboardTemp extends StatelessWidget {
  const HomeDashboardTemp({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: HomeDashboard());
}

class TodoMainTemp extends StatelessWidget {
  const TodoMainTemp({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: TodoMain());
}
// -------------------------

class HomeScreen extends StatefulWidget {
  // The onToggleTheme parameter is no longer needed
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeDashboard(), // Dashboard summary
      const HealthManagerHome(), // Health component
      const Center(child: Text("Finance Screen")),
      const Center(child: Text("Productivity Screen")),
      const TodoMain(),
      const Center(child: Text("Routine Screen")),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final themeProvider = Provider.of<ThemeNotifier>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // This now navigates to your Profile Screen
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      // The main body of the screen, which changes based on the selected tab
      body: _pages[_selectedIndex],

      // Your bottom navigation bar remains the same
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: isDark ? Colors.white54 : Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Health"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Finance"),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "Productivity"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "To-Do"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Routine"),
        ],
      ),

 
    );
  }
}
