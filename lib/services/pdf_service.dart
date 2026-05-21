import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/checklist_item.dart';
import '../models/protokoll.dart';
import '../models/pruf_status.dart';
import '../models/rcd_messung.dart';

class PdfService {
  static const _kBlue = PdfColor.fromInt(0xFF003461);
  static const _kSecondary = PdfColor.fromInt(0xFF48626e);
  static const _kGreen = PdfColor.fromInt(0xFF008a00);
  static const _kRed = PdfColor.fromInt(0xFFba1a1a);
  static const _kGray = PdfColor.fromInt(0xFF727781);
  static const _kOutline = PdfColor.fromInt(0xFFc2c6d1);
  static const _kWhite = PdfColors.white;

  static Future<void> exportAndShare(Protokoll p, String prueferName) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.iBMPlexSansRegular();
    final fontBold = await PdfGoogleFonts.iBMPlexSansBold();

    pw.MemoryImage? sigImage;
    if (p.unterschriftBase64 != null) {
      sigImage = pw.MemoryImage(base64Decode(p.unterschriftBase64!));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (ctx) => _buildPage1(ctx, p, prueferName, font, fontBold, sigImage),
      ),
    );

    if (p.rcdMessungen.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (ctx) => _buildPage2(p, font, fontBold),
        ),
      );
    }

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Protokoll_${p.auftragsnummer}_${p.schrankId}.pdf',
    );
  }

  static List<pw.Widget> _buildPage1(
    pw.Context ctx,
    Protokoll p,
    String prueferName,
    pw.Font font,
    pw.Font fontBold,
    pw.MemoryImage? sigImage,
  ) {
    final date = '${p.datum.day.toString().padLeft(2, '0')}.${p.datum.month.toString().padLeft(2, '0')}.${p.datum.year}';

    return [
      _header(p, prueferName, date, font, fontBold),
      pw.SizedBox(height: 16),
      _checklistSection(p, font, fontBold),
      pw.SizedBox(height: 16),
      if (p.bemerkungen.isNotEmpty) _bemerkungenSection(p.bemerkungen, font, fontBold),
      if (p.bemerkungen.isNotEmpty) pw.SizedBox(height: 16),
      _sigAndFreigabeRow(p.freigegeben, sigImage, font, fontBold),
    ];
  }

  static pw.Widget _header(Protokoll p, String prueferName, String date, pw.Font font, pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _kBlue,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Schaltschrank-Abnahmeprotokoll',
                style: pw.TextStyle(font: fontBold, fontSize: 16, color: _kWhite),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${p.auftragsnummer} · ${p.schrankId}',
                style: pw.TextStyle(font: font, fontSize: 12, color: PdfColor.fromInt(0xFFa3c9ff)),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(date, style: pw.TextStyle(font: font, fontSize: 11, color: _kWhite)),
              pw.Text(
                'Ersteller: ${p.ersteller}  |  Prüfer: $prueferName',
                style: pw.TextStyle(font: font, fontSize: 10, color: PdfColor.fromInt(0xFFa3c9ff)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _checklistSection(Protokoll p, pw.Font font, pw.Font fontBold) {
    final groups = <String, List<ChecklistItem>>{};
    for (final item in p.checkliste) {
      groups.putIfAbsent(item.kategorie, () => []).add(item);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: groups.entries.map((entry) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(
                entry.key.toUpperCase(),
                style: pw.TextStyle(font: fontBold, fontSize: 9, color: _kBlue, letterSpacing: 0.8),
              ),
            ),
            pw.Table(
              border: pw.TableBorder.all(color: _kOutline, width: 0.5),
              columnWidths: {0: const pw.FlexColumnWidth(4), 1: const pw.FixedColumnWidth(80)},
              children: entry.value.map((item) => _checklistRow(item, font, fontBold)).toList(),
            ),
            pw.SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  static pw.TableRow _checklistRow(ChecklistItem item, pw.Font font, pw.Font fontBold) {
    String statusLabel;
    PdfColor statusColor;
    switch (item.status) {
      case PruefStatus.bestanden:
        statusLabel = 'BESTANDEN';
        statusColor = _kGreen;
      case PruefStatus.durchgefallen:
        statusLabel = 'DURCHGEFALLEN';
        statusColor = _kRed;
      case PruefStatus.na:
        statusLabel = 'N/A';
        statusColor = _kGray;
      case PruefStatus.unset:
        statusLabel = '—';
        statusColor = _kGray;
    }

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(item.bezeichnung, style: pw.TextStyle(font: font, fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(statusLabel, style: pw.TextStyle(font: fontBold, fontSize: 9, color: statusColor)),
        ),
      ],
    );
  }

  static pw.Widget _bemerkungenSection(String text, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('BEMERKUNGEN', style: pw.TextStyle(font: fontBold, fontSize: 9, color: _kBlue, letterSpacing: 0.8)),
        pw.SizedBox(height: 4),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _kOutline, width: 0.5),
            borderRadius: pw.BorderRadius.circular(2),
          ),
          child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 10)),
        ),
      ],
    );
  }

  static pw.Widget _sigAndFreigabeRow(
    bool? freigegeben,
    pw.MemoryImage? sigImage,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final label = freigegeben == true
        ? 'Schrank zur Auslieferung\nFREIGEGEBEN'
        : freigegeben == false
            ? 'Schrank zur Auslieferung\nNICHT FREIGEGEBEN'
            : 'Keine Freigabe-\nentscheidung getroffen';
    final color = freigegeben == true ? _kGreen : freigegeben == false ? _kRed : _kGray;

    final sigWidget = sigImage != null
        ? pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('UNTERSCHRIFT',
                  style: pw.TextStyle(font: fontBold, fontSize: 9, color: _kSecondary, letterSpacing: 0.8)),
              pw.SizedBox(height: 4),
              pw.Container(
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: _kOutline, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(2),
                  color: PdfColors.white,
                ),
                child: pw.Image(sigImage, fit: pw.BoxFit.contain),
              ),
            ],
          )
        : pw.Container(
            height: 80,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _kOutline, width: 0.5),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            child: pw.Center(
              child: pw.Text('Keine Unterschrift',
                  style: pw.TextStyle(font: font, fontSize: 9, color: _kGray)),
            ),
          );

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 3,
          child: sigWidget,
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: color, width: 1.5),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              label,
              style: pw.TextStyle(font: fontBold, fontSize: 11, color: color),
            ),
          ),
        ),
      ],
    );
  }


  static pw.Widget _buildPage2(Protokoll p, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'RCD-Messergebnisse',
          style: pw.TextStyle(font: fontBold, fontSize: 16, color: _kBlue),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${p.auftragsnummer} · ${p.schrankId}',
          style: pw.TextStyle(font: font, fontSize: 11, color: _kSecondary),
        ),
        pw.SizedBox(height: 16),
        _rcdTable(p.rcdMessungen, font, fontBold),
      ],
    );
  }

  static pw.Widget _rcdTable(List<RcdMessung> messungen, pw.Font font, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: _kOutline, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FixedColumnWidth(90),
        2: const pw.FixedColumnWidth(90),
        3: const pw.FixedColumnWidth(90),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _kBlue),
          children: ['RCD NAME / ID', 'AUSLÖSEZEIT (ms)', 'AUSLÖSESTROM (mA)', 'STATUS']
              .map(
                (h) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 9, color: _kWhite)),
                ),
              )
              .toList(),
        ),
        ...messungen.map((m) {
          String statusLabel;
          PdfColor statusColor;
          switch (m.status) {
            case PruefStatus.bestanden:
              statusLabel = 'BESTANDEN';
              statusColor = _kGreen;
            case PruefStatus.durchgefallen:
              statusLabel = 'DURCHGEFALLEN';
              statusColor = _kRed;
            case PruefStatus.na:
              statusLabel = 'N/A';
              statusColor = _kGray;
            case PruefStatus.unset:
              statusLabel = '—';
              statusColor = _kGray;
          }

          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: pw.Text(m.name, style: pw.TextStyle(font: font, fontSize: 10)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: pw.Text(
                  m.ausloesezeit != null ? '${m.ausloesezeit}' : '—',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: pw.Text(
                  m.ausloesestrom != null ? '${m.ausloesestrom}' : '—',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: pw.Text(statusLabel, style: pw.TextStyle(font: fontBold, fontSize: 10, color: statusColor)),
              ),
            ],
          );
        }),
      ],
    );
  }
}
