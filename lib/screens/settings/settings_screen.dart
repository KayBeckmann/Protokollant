import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/app_settings.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _prueferCtrl;
  late TextEditingController _neuerErstellerCtrl;

  @override
  void initState() {
    super.initState();
    final settings = context.read<AppProvider>().settings;
    _prueferCtrl = TextEditingController(text: settings.prueferName);
    _neuerErstellerCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _prueferCtrl.dispose();
    _neuerErstellerCtrl.dispose();
    super.dispose();
  }

  void _savePruefer() {
    final provider = context.read<AppProvider>();
    final updated = AppSettings(
      prueferName: _prueferCtrl.text.trim(),
      erstellerListe: List.from(provider.settings.erstellerListe),
    );
    provider.updateSettings(updated);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prüfer gespeichert')),
    );
  }

  void _addErsteller() {
    final name = _neuerErstellerCtrl.text.trim();
    if (name.isEmpty) return;
    final provider = context.read<AppProvider>();
    final list = List<String>.from(provider.settings.erstellerListe);
    if (list.contains(name)) return;
    list.add(name);
    provider.updateSettings(AppSettings(prueferName: provider.settings.prueferName, erstellerListe: list));
    _neuerErstellerCtrl.clear();
  }

  void _removeErsteller(String name) {
    final provider = context.read<AppProvider>();
    final list = List<String>.from(provider.settings.erstellerListe)..remove(name);
    provider.updateSettings(AppSettings(prueferName: provider.settings.prueferName, erstellerListe: list));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppProvider>().settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('Prüfer'),
          const SizedBox(height: 12),
          TextField(
            controller: _prueferCtrl,
            decoration: const InputDecoration(labelText: 'NAME DES PRÜFERS'),
            style: GoogleFonts.ibmPlexSans(fontSize: 16),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _savePruefer(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _savePruefer,
              child: const Text('Speichern'),
            ),
          ),
          const SizedBox(height: 24),
          _sectionLabel('Ersteller-Liste'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _neuerErstellerCtrl,
                  decoration: const InputDecoration(labelText: 'NEUER ERSTELLER'),
                  style: GoogleFonts.ibmPlexSans(fontSize: 16),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addErsteller(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addErsteller,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (settings.erstellerListe.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSurfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: kOutlineVariant),
              ),
              child: Text(
                'Noch keine Ersteller eingetragen.',
                style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: kOutlineVariant),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Column(
                children: settings.erstellerListe.asMap().entries.map((entry) {
                  final isLast = entry.key == settings.erstellerListe.length - 1;
                  return Container(
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(bottom: BorderSide(color: kOutlineVariant)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        entry.value,
                        style: GoogleFonts.ibmPlexSans(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: kOnSurfaceVariant),
                        onPressed: () => _removeErsteller(entry.value),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.ibmPlexSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.05,
        color: kPrimary,
      ),
    );
  }
}
