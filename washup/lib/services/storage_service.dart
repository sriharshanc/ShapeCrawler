import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/laundry_plan.dart';
import '../models/laundry_settings.dart';

/// Persists building configuration and the current plan locally, and keeps
/// a running tally of past assignments so a freshly generated plan stays
/// fair relative to history instead of resetting every time.
class StorageService {
  static const _settingsKey = 'washup.settings.v1';
  static const _planKey = 'washup.plan.v1';
  static const _historyCountsKey = 'washup.historyCounts.v1';

  Future<LaundrySettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) return LaundrySettings.initial();
    try {
      return LaundrySettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return LaundrySettings.initial();
    }
  }

  Future<void> saveSettings(LaundrySettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<LaundryPlan?> loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_planKey);
    if (raw == null) return null;
    try {
      return LaundryPlan.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> savePlan(LaundryPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planKey, jsonEncode(plan.toJson()));
  }

  /// Cumulative appliance-slot counts per flat id, carried across every
  /// plan ever generated, so long-run fairness holds even if the app is
  /// used period after period (the exact bias the paper rota suffered
  /// from: a few names always coming out ahead).
  Future<Map<String, int>> loadHistoryCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyCountsKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> addToHistoryCounts(Map<String, int> counts) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadHistoryCounts();
    for (final entry in counts.entries) {
      existing[entry.key] = (existing[entry.key] ?? 0) + entry.value;
    }
    await prefs.setString(_historyCountsKey, jsonEncode(existing));
  }

  Future<void> resetHistoryCounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyCountsKey);
  }
}
