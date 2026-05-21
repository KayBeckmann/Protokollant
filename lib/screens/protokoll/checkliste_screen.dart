import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/checklist_item.dart';
import '../../models/protokoll.dart';
import '../../models/pruf_status.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tristate_toggle.dart';
import 'rcd_screen.dart';

class ChecklisteScreen extends StatefulWidget {
  final String protokollId;

  const ChecklisteScreen({super.key, required this.protokollId});

  @override
  State<ChecklisteScreen> createState() => _ChecklisteScreenState();
}

class _ChecklisteScreenState extends State<ChecklisteScreen> {
  late Protokoll _protokoll;
  late TextEditingController _bemerkungCtrl;

  @override
  void initState() {
    super.initState();
    _protokoll = context.read<AppProvider>().getById(widget.protokollId)!;
    _bemerkungCtrl = TextEditingController(text: _protokoll.bemerkungen);
  }

  @override
  void dispose() {
    _bemerkungCtrl.dispose();
    super.dispose();
  }

  void _updateStatus(int index, PruefStatus status) {
    setState(() => _protokoll.checkliste[index].status = status);
    _saveProgress();
  }

  void _saveProgress() {
    _protokoll.bemerkungen = _bemerkungCtrl.text;
    context.read<AppProvider>().saveProtokoll(_protokoll);
  }

  void _weiter() {
    _saveProgress();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RcdScreen(protokollId: _protokoll.id)),
    );
  }

  Map<String, List<ChecklistItem>> get _grouped {
    final map = <String, List<ChecklistItem>>{};
    for (final item in _protokoll.checkliste) {
      map.putIfAbsent(item.kategorie, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _grouped;
    final bestehenCount = _protokoll.checkliste.where((c) => c.status != PruefStatus.unset).length;
    final total = _protokoll.checkliste.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkliste'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$bestehenCount/$total',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kOnSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text(
            '${_protokoll.auftragsnummer} · ${_protokoll.schrankId}',
            style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: total > 0 ? bestehenCount / total : 0,
            backgroundColor: kSurfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(kPrimary),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          ...groups.entries.map((entry) => _buildGroup(entry.key, entry.value)),
          const SizedBox(height: 24),
          _buildBemerkung(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildGroup(String kategorie, List<ChecklistItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  kategorie.toUpperCase(),
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                    color: kPrimary,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: kOutlineVariant)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kOutlineVariant),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final globalIndex = _protokoll.checkliste.indexOf(entry.value);
              return _ChecklistRow(
                item: entry.value,
                isLast: entry.key == items.length - 1,
                onChanged: (s) => _updateStatus(globalIndex, s),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBemerkung() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BEMERKUNGSFELD',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
            color: kPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bemerkungCtrl,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Zusätzliche Anmerkungen oder Mängelbeschreibung...',
            hintStyle: GoogleFonts.ibmPlexSans(fontSize: 14, color: kOutline),
          ),
          style: GoogleFonts.ibmPlexSans(fontSize: 14),
          onChanged: (_) => _saveProgress(),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kOutlineVariant)),
      ),
      child: ElevatedButton.icon(
        onPressed: _weiter,
        icon: const Icon(Icons.electrical_services),
        label: const Text('Weiter: RCD-Messungen'),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final ChecklistItem item;
  final bool isLast;
  final ValueChanged<PruefStatus> onChanged;

  const _ChecklistRow({
    required this.item,
    required this.isLast,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: kOutlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              item.bezeichnung,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kOnSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TristateToggle(value: item.status, onChanged: onChanged, compact: true),
        ],
      ),
    );
  }
}
