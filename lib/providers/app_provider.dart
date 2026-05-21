import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/protokoll.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final _storage = StorageService();

  List<Protokoll> _protokolle = [];
  AppSettings _settings = AppSettings();

  List<Protokoll> get protokolle => List.unmodifiable(_protokolle);
  AppSettings get settings => _settings;

  int get inArbeitCount =>
      _protokolle.where((p) => p.status == ProtokollStatus.inArbeit).length;
  int get abgeschlossenCount =>
      _protokolle.where((p) => p.status == ProtokollStatus.abgeschlossen).length;

  void init() {
    _protokolle = _storage.loadAll();
    _settings = _storage.loadSettings();
    notifyListeners();
  }

  void saveProtokoll(Protokoll p) {
    final idx = _protokolle.indexWhere((x) => x.id == p.id);
    if (idx >= 0) {
      _protokolle[idx] = p;
    } else {
      _protokolle.insert(0, p);
    }
    _storage.save(p);
    notifyListeners();
  }

  void deleteProtokoll(String id) {
    _protokolle.removeWhere((p) => p.id == id);
    _storage.delete(id);
    notifyListeners();
  }

  Protokoll? getById(String id) {
    try {
      return _protokolle.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateSettings(AppSettings s) {
    _settings = s;
    _storage.saveSettings(s);
    notifyListeners();
  }
}
