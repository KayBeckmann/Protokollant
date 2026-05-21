import 'package:hive_flutter/hive_flutter.dart';
import '../models/protokoll.dart';
import '../models/app_settings.dart';

class StorageService {
  static const _protokolleBox = 'protokolle';
  static const _settingsKey = 'app_settings';
  static const _settingsBox = 'settings';

  Box<String> get _protokolle => Hive.box<String>(_protokolleBox);
  Box<String> get _settings => Hive.box<String>(_settingsBox);

  List<Protokoll> loadAll() {
    return _protokolle.values
        .map((s) => Protokoll.fromJsonString(s))
        .toList()
      ..sort((a, b) => b.datum.compareTo(a.datum));
  }

  void save(Protokoll p) {
    _protokolle.put(p.id, p.toJsonString());
  }

  void delete(String id) {
    _protokolle.delete(id);
  }

  AppSettings loadSettings() {
    final s = _settings.get(_settingsKey);
    if (s == null) return AppSettings();
    return AppSettings.fromJsonString(s);
  }

  void saveSettings(AppSettings settings) {
    _settings.put(_settingsKey, settings.toJsonString());
  }
}
