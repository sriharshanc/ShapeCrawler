import 'package:flutter/material.dart';

import 'fairness_screen.dart';
import 'flats_screen.dart';
import 'schedule_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    ScheduleScreen(),
    FairnessScreen(),
    FlatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Plan'),
          NavigationDestination(icon: Icon(Icons.balance_outlined), label: 'Fairness'),
          NavigationDestination(icon: Icon(Icons.door_front_door_outlined), label: 'Flats'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Setup'),
        ],
      ),
    );
  }
}
