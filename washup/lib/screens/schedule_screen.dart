import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/laundry_plan.dart';
import '../models/laundry_settings.dart';
import '../models/schedule_entry.dart';
import '../services/app_state.dart';
import '../widgets/day_schedule_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final plan = appState.plan;
    final settings = appState.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Washup'),
        actions: [
          IconButton(
            tooltip: 'Generate a new fair plan',
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => _generate(context),
          ),
        ],
      ),
      body: plan == null
          ? _EmptyState(onGenerate: () => _generate(context))
          : _PlanList(plan: plan, settings: settings),
      floatingActionButton: plan == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _generate(context),
              icon: const Icon(Icons.refresh),
              label: const Text('New plan'),
            ),
    );
  }

  Future<void> _generate(BuildContext context) async {
    final appState = context.read<AppState>();
    try {
      await appState.generatePlan();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_laundry_service_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              'No rota yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Set up your floors, flats and machines in Settings, '
              'then generate a fair plan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate plan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanList extends StatelessWidget {
  const _PlanList({required this.plan, required this.settings});

  final LaundryPlan plan;
  final LaundrySettings settings;

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<ScheduleEntry>> byDay = {};
    for (final e in plan.entries) {
      final key = DateTime(e.date.year, e.date.month, e.date.day);
      byDay.putIfAbsent(key, () => []).add(e);
    }
    final days = byDay.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return DayScheduleCard(date: day, entries: byDay[day]!, settings: settings);
      },
    );
  }
}
