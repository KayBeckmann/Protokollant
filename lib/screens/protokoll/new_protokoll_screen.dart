import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/protokoll.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import 'checkliste_screen.dart';

class NewProtokollScreen extends StatefulWidget {
  final String? protokollId;

  const NewProtokollScreen({super.key, this.protokollId});

  @override
  State<NewProtokollScreen> createState() => _NewProtokollScreenState();
}

class _NewProtokollScreenState extends State<NewProtokollScreen> {
  final _formKey = GlobalKey<FormState>();
  late Protokoll _protokoll;
  late TextEditingController _auftragCtrl;
  late TextEditingController _schrankCtrl;
  String? _erstellerValue;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    if (widget.protokollId != null) {
      _protokoll = provider.getById(widget.protokollId!)!;
      _isNew = false;
    } else {
      _protokoll = Protokoll(ersteller: provider.settings.erstellerListe.isNotEmpty
          ? provider.settings.erstellerListe.first
          : '');
      _isNew = true;
    }
    _auftragCtrl = TextEditingController(text: _protokoll.auftragsnummer);
    _schrankCtrl = TextEditingController(text: _protokoll.schrankId);
    _erstellerValue = _protokoll.ersteller.isNotEmpty ? _protokoll.ersteller : null;
  }

  @override
  void dispose() {
    _auftragCtrl.dispose();
    _schrankCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _protokoll.auftragsnummer = _auftragCtrl.text.trim();
    _protokoll.schrankId = _schrankCtrl.text.trim();
    _protokoll.ersteller = _erstellerValue ?? '';
    if (_isNew) _protokoll.status = ProtokollStatus.inArbeit;
    context.read<AppProvider>().saveProtokoll(_protokoll);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChecklisteScreen(protokollId: _protokoll.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final erstellerListe = provider.settings.erstellerListe;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'Neues Protokoll' : 'Protokoll bearbeiten'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionLabel('Auftragsinformationen'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _auftragCtrl,
              decoration: const InputDecoration(labelText: 'AUFTRAGSNUMMER'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
              style: GoogleFonts.ibmPlexSans(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _schrankCtrl,
              decoration: const InputDecoration(labelText: 'SCHRANK-ID'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
              style: GoogleFonts.ibmPlexSans(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Prüfer & Ersteller'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kOutlineVariant),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRÜFER',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.05,
                            color: kOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.settings.prueferName.isEmpty
                              ? '(nicht konfiguriert)'
                              : provider.settings.prueferName,
                          style: GoogleFonts.ibmPlexSans(fontSize: 16, color: kOnSurface),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.person_outline, color: kOnSurfaceVariant),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (erstellerListe.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSurfaceContainerLow,
                  border: Border.all(color: kOutlineVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Keine Ersteller konfiguriert. Bitte in Einstellungen hinzufügen.',
                  style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
                ),
              )
            else
              DropdownButtonFormField<String>(
                initialValue: _erstellerValue,
                decoration: const InputDecoration(labelText: 'ERSTELLER'),
                items: erstellerListe
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _erstellerValue = v),
                style: GoogleFonts.ibmPlexSans(fontSize: 16, color: kOnSurface),
                validator: (v) => v == null ? 'Bitte Ersteller wählen' : null,
              ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('Zur Checkliste'),
            ),
            if (!_isNew) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Protokoll löschen'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kError,
                  side: const BorderSide(color: kError),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Protokoll löschen?'),
        content: const Text('Dieser Vorgang kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          TextButton(
            onPressed: () {
              context.read<AppProvider>().deleteProtokoll(_protokoll.id);
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Löschen', style: TextStyle(color: kError)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
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
