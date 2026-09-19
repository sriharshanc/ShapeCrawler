import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flat.dart';
import '../services/app_state.dart';

class FlatsScreen extends StatelessWidget {
  const FlatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final flats = appState.settings.flats;
    final byFloor = <int, List<Flat>>{};
    for (final f in flats) {
      byFloor.putIfAbsent(f.floor, () => []).add(f);
    }
    final floors = byFloor.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flats & tenants'),
      ),
      body: flats.isEmpty
          ? const Center(child: Text('Configure floors and flats in Settings first.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Rename a flat to match the tenant, or switch a flat off '
                    'if it should sit out of the rota (e.g. vacant unit).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                for (final floor in floors) ...[
                  Text('Floor $floor', style: Theme.of(context).textTheme.titleSmall),
                  for (final flat in byFloor[floor]!)
                    _FlatTile(
                      flat: flat,
                      onRename: (name) => _updateFlat(context, flat.copyWith(name: name)),
                      onToggle: (active) => _updateFlat(context, flat.copyWith(active: active)),
                    ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }

  void _updateFlat(BuildContext context, Flat updated) {
    final appState = context.read<AppState>();
    final flats = [
      for (final f in appState.settings.flats)
        if (f.id == updated.id) updated else f,
    ];
    appState.updateSettings(appState.settings.copyWith(flats: flats));
  }
}

class _FlatTile extends StatelessWidget {
  const _FlatTile({required this.flat, required this.onRename, required this.onToggle});

  final Flat flat;
  final ValueChanged<String> onRename;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(flat.id.substring(1))),
        title: TextFormField(
          key: ValueKey(flat.id),
          initialValue: flat.name,
          decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: onRename,
        ),
        subtitle: Text(flat.active ? 'In rota' : 'Excluded from rota'),
        trailing: Switch(value: flat.active, onChanged: onToggle),
      ),
    );
  }
}
