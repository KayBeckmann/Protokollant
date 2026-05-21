import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/protokoll.dart';
import '../../models/rcd_messung.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tristate_toggle.dart';
import 'abschluss_screen.dart';

class RcdScreen extends StatefulWidget {
  final String protokollId;

  const RcdScreen({super.key, required this.protokollId});

  @override
  State<RcdScreen> createState() => _RcdScreenState();
}

class _RcdScreenState extends State<RcdScreen> {
  late Protokoll _protokoll;

  @override
  void initState() {
    super.initState();
    _protokoll = context.read<AppProvider>().getById(widget.protokollId)!;
  }

  void _addRcd() {
    setState(() => _protokoll.rcdMessungen.add(RcdMessung()));
    _save();
  }

  void _removeRcd(int index) {
    setState(() => _protokoll.rcdMessungen.removeAt(index));
    _save();
  }

  void _save() {
    context.read<AppProvider>().saveProtokoll(_protokoll);
  }

  void _weiter() {
    _save();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AbschlussScreen(protokollId: _protokoll.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RCD-Messungen')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text(
            'Auslösezeit und Auslösestrom je FI/RCD erfassen.',
            style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
          ),
          const SizedBox(height: 16),
          ..._protokoll.rcdMessungen.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RcdCard(
                    messung: e.value,
                    onRemove: () => _removeRcd(e.key),
                    onChanged: _save,
                  ),
                ),
              ),
          _buildAddButton(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _addRcd,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: kOutlineVariant, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(4),
          color: kSurface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: kSecondary),
            const SizedBox(width: 8),
            Text(
              'RCD hinzufügen',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kSecondary,
              ),
            ),
          ],
        ),
      ),
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
        icon: const Icon(Icons.assignment_turned_in_outlined),
        label: const Text('Weiter: Abschluss'),
      ),
    );
  }
}

class _RcdCard extends StatefulWidget {
  final RcdMessung messung;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _RcdCard({required this.messung, required this.onRemove, required this.onChanged});

  @override
  State<_RcdCard> createState() => _RcdCardState();
}

class _RcdCardState extends State<_RcdCard> {
  late TextEditingController _nameCtrl;
  late TextEditingController _zeitCtrl;
  late TextEditingController _stromCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.messung.name);
    _zeitCtrl = TextEditingController(
      text: widget.messung.ausloesezeit != null ? '${widget.messung.ausloesezeit}' : '',
    );
    _stromCtrl = TextEditingController(
      text: widget.messung.ausloesestrom != null ? '${widget.messung.ausloesestrom}' : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _zeitCtrl.dispose();
    _stromCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    widget.messung.name = _nameCtrl.text.trim();
    widget.messung.ausloesezeit = double.tryParse(_zeitCtrl.text);
    widget.messung.ausloesestrom = double.tryParse(_stromCtrl.text);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kOutlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'RCD NAME / ID'),
                  style: GoogleFonts.ibmPlexSans(fontSize: 15),
                  onChanged: (_) => _sync(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete_outline),
                color: kOnSurfaceVariant,
                tooltip: 'Entfernen',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _zeitCtrl,
                  decoration: InputDecoration(
                    labelText: 'AUSLÖSEZEIT',
                    suffixText: 'ms',
                    suffixStyle: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.ibmPlexSans(fontSize: 15, fontFeatures: const [FontFeature.tabularFigures()]),
                  onChanged: (_) => _sync(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _stromCtrl,
                  decoration: InputDecoration(
                    labelText: 'AUSLÖSESTROM',
                    suffixText: 'mA',
                    suffixStyle: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.ibmPlexSans(fontSize: 15, fontFeatures: const [FontFeature.tabularFigures()]),
                  onChanged: (_) => _sync(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: kOutlineVariant, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Test-Status',
                style: GoogleFonts.ibmPlexSans(fontSize: 13, fontWeight: FontWeight.w600, color: kOnSurfaceVariant),
              ),
              TristateToggle(
                value: widget.messung.status,
                onChanged: (s) {
                  setState(() => widget.messung.status = s);
                  widget.onChanged();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
