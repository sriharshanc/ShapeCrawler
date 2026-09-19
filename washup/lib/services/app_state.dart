import 'package:flutter/foundation.dart';

import '../models/laundry_plan.dart';
import '../models/laundry_settings.dart';
import 'scheduler_service.dart';
import 'storage_service.dart';

/// Central, in-memory source of truth for the running app. Loads persisted
/// settings/plan on startup and keeps them in sync with local storage.
class AppState extends ChangeNotifier {
  AppState({StorageService? storage, SchedulerService? scheduler})
      : _storage = storage ?? StorageService(),
        _scheduler = scheduler ?? SchedulerService();

  final StorageService _storage;
  final SchedulerService _scheduler;

  LaundrySettings _settings = LaundrySettings.initial();
  LaundryPlan? _plan;
  bool _loading = true;

  LaundrySettings get settings => _settings;
  LaundryPlan? get plan => _plan;
  bool get loading => _loading;

  Future<void> load() async {
    _settings = await _storage.loadSettings();
    _plan = await _storage.loadPlan();
    _loading = false;
    notifyListeners();
  }

  Future<void> updateSettings(LaundrySettings settings) async {
    _settings = settings;
    await _storage.saveSettings(settings);
    notifyListeners();
  }

  /// Generates a fresh plan for the current settings, carrying forward
  /// historical per-flat counts so fairness compounds correctly across
  /// repeated generations instead of resetting every time.
  Future<void> generatePlan({DateTime? startDate}) async {
    final carryIn = await _storage.loadHistoryCounts();
    final newPlan = _scheduler.generatePlan(
      settings: _settings,
      startDate: startDate ?? DateTime.now(),
      carryInCounts: carryIn,
    );
    await _storage.addToHistoryCounts(newPlan.countsByFlat());
    await _storage.savePlan(newPlan);
    _plan = newPlan;
    notifyListeners();
  }

  Future<void> resetFairnessHistory() async {
    await _storage.resetHistoryCounts();
    notifyListeners();
  }
}
