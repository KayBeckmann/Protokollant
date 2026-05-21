import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../models/protokoll.dart';
import '../../providers/app_provider.dart';
import '../../services/pdf_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/signature_pad_widget.dart';

class AbschlussScreen extends StatefulWidget {
  final String protokollId;

  const AbschlussScreen({super.key, required this.protokollId});

  @override
  State<AbschlussScreen> createState() => _AbschlussScreenState();
}

class _AbschlussScreenState extends State<AbschlussScreen> {
  late Protokoll _protokoll;
  late SignatureController _sigCtrl;
  bool _isExporting = false;
  DateTime? _signedAt;

  @override
  void initState() {
    super.initState();
    _protokoll = context.read<AppProvider>().getById(widget.protokollId)!;
    _sigCtrl = SignatureController(
      penStrokeWidth: 2.5,
      penColor: kPrimary,
      exportBackgroundColor: Colors.white,
    );
    if (_protokoll.unterschriftBase64 != null) {
      _signedAt = _protokoll.datum;
    }
  }

  @override
  void dispose() {
    _sigCtrl.dispose();
    super.dispose();
  }

  void _setFreigabe(bool value) {
    setState(() => _protokoll.freigegeben = value);
    context.read<AppProvider>().saveProtokoll(_protokoll);
  }

  Future<void> _exportPdf() async {
    if (_protokoll.freigegeben == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Gesamtergebnis festlegen')),
      );
      return;
    }

    final provider = context.read<AppProvider>();
    final prueferName = provider.settings.prueferName;

    if (_sigCtrl.isNotEmpty && _protokoll.unterschriftBase64 == null) {
      final bytes = await _sigCtrl.toPngBytes();
      if (bytes != null) {
        setState(() {
          _protokoll.unterschriftBase64 = base64Encode(bytes);
          _signedAt = DateTime.now();
        });
      }
    }

    setState(() => _isExporting = true);
    _protokoll.status = ProtokollStatus.abgeschlossen;
    provider.saveProtokoll(_protokoll);
    try {
      await PdfService.exportAndShare(_protokoll, prueferName);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final geprueft = _protokoll.geprueftCount;
    final gesamt = _protokoll.checkliste.length;
    final kritisch = _protokoll.durchgefallenCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Abschluss')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Text(
            'Abschlussprüfung',
            style: GoogleFonts.ibmPlexSans(fontSize: 22, fontWeight: FontWeight.w600, color: kOnSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Überprüfen Sie die Daten, legen Sie das Gesamtergebnis fest und signieren Sie.',
            style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
          ),
          const SizedBox(height: 20),
          _buildSummary(geprueft, gesamt, kritisch),
          const SizedBox(height: 20),
          _buildFreigabe(),
          const SizedBox(height: 20),
          _buildSignaturSection(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSummary(int geprueft, int gesamt, int kritisch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INSPEKTIONSZUSAMMENFASSUNG',
          style: GoogleFonts.ibmPlexSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, color: kSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(label: 'Anlage / ID', value: _protokoll.schrankId.isEmpty ? '—' : _protokoll.schrankId),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(label: 'Prüfer', value: context.read<AppProvider>().settings.prueferName.isEmpty ? '—' : context.read<AppProvider>().settings.prueferName),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kOutlineVariant),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GEPRÜFTE PUNKTE', style: GoogleFonts.ibmPlexSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, color: kOnSurfaceVariant)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('$geprueft', style: GoogleFonts.ibmPlexSans(fontSize: 24, fontWeight: FontWeight.w600, color: kOnSurface)),
                      const SizedBox(width: 6),
                      Text('von $gesamt', style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kSecondary)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('KRITISCH', style: GoogleFonts.ibmPlexSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, color: kOnSurfaceVariant)),
                  Text('$kritisch', style: GoogleFonts.ibmPlexSans(fontSize: 20, fontWeight: FontWeight.w600, color: kritisch > 0 ? kError : kOnSurface)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFreigabe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRÜFUNG: GESAMTERGEBNIS',
          style: GoogleFonts.ibmPlexSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, color: kSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: kPrimary),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setFreigabe(true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      color: _protokoll.freigegeben == true ? kPrimary : Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: _protokoll.freigegeben == true ? Colors.white : kSecondary, size: 18),
                          const SizedBox(width: 6),
                          Text('Bestanden', style: GoogleFonts.ibmPlexSans(fontSize: 13, fontWeight: FontWeight.w600, color: _protokoll.freigegeben == true ? Colors.white : kSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: kOutlineVariant),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setFreigabe(false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      color: _protokoll.freigegeben == false ? kError : Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel, color: _protokoll.freigegeben == false ? Colors.white : kSecondary, size: 18),
                          const SizedBox(width: 6),
                          Text('Durchgefallen', style: GoogleFonts.ibmPlexSans(fontSize: 13, fontWeight: FontWeight.w600, color: _protokoll.freigegeben == false ? Colors.white : kSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_protokoll.freigegeben != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _protokoll.freigegeben!
                  ? 'Anlage ist betriebsbereit.'
                  : 'Anlage ist nicht betriebsbereit.',
              style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }

  Widget _buildSignaturSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DIGITALE SIGNATUR',
          style: GoogleFonts.ibmPlexSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, color: kSecondary),
        ),
        const SizedBox(height: 8),
        SignaturePadWidget(controller: _sigCtrl, signedAt: _signedAt),
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
        onPressed: _isExporting ? null : _exportPdf,
        icon: _isExporting
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.picture_as_pdf),
        label: const Text('PDF Protokoll erzeugen'),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({required this.label, required this.value});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.ibmPlexSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05, color: kOnSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.ibmPlexSans(fontSize: 15, fontWeight: FontWeight.w500, color: kOnSurface)),
        ],
      ),
    );
  }
}
