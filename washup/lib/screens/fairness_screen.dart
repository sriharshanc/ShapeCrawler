import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class FairnessScreen extends StatelessWidget {
  const FairnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final plan = appState.plan;
    final flats = appState.settings.flats.where((f) => f.active).toList();

    if (plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fairness')),
        body: const Center(child: Text('Generate a plan to see the fairness breakdown.')),
      );
    }

    final counts = plan.countsByFlat();
    final maxCount = counts.values.isEmpty ? 0 : counts.values.reduce((a, b) => a > b ? a : b);
    final minCount = flats.isEmpty
        ? 0
        : flats.map((f) => counts[f.id] ?? 0).reduce((a, b) => a < b ? a : b);
    final sorted = [...flats]..sort((a, b) => (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0));

    return Scaffold(
      appBar: AppBar(title: const Text('Fairness')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('This plan', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    maxCount - minCount <= 1
                        ? 'Every flat is within one appliance-slot of every '
                            'other flat — as fair as the schedule allows.'
                        : 'Spread of $minCount–$maxCount slots per flat. '
                            'Large gaps usually mean some flats are excluded '
                            'or the plan is too short for the flat count.',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Random seed: ${plan.fairnessSeed} · assignments are '
                    'drawn from the least-used flats at random, never by '
                    'list order, so nobody is systematically favoured.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Slots per flat (this plan)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final flat in sorted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text(flat.name, overflow: TextOverflow.ellipsis)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: maxCount == 0 ? 0 : (counts[flat.id] ?? 0) / maxCount,
                        minHeight: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 24,
                    child: Text('${counts[flat.id] ?? 0}', textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
