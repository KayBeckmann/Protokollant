import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'checklist_item.dart';
import 'pruf_status.dart';
import 'rcd_messung.dart';

enum ProtokollStatus { neu, inArbeit, abgeschlossen }

class Protokoll {
  final String id;
  String auftragsnummer;
  String schrankId;
  String ersteller;
  DateTime datum;
  List<ChecklistItem> checkliste;
  List<RcdMessung> rcdMessungen;
  String bemerkungen;
  bool? freigegeben;
  String? unterschriftBase64;
  ProtokollStatus status;

  Protokoll({
    String? id,
    this.auftragsnummer = '',
    this.schrankId = '',
    this.ersteller = '',
    DateTime? datum,
    List<ChecklistItem>? checkliste,
    List<RcdMessung>? rcdMessungen,
    this.bemerkungen = '',
    this.freigegeben,
    this.unterschriftBase64,
    this.status = ProtokollStatus.neu,
  })  : id = id ?? const Uuid().v4(),
        datum = datum ?? DateTime.now(),
        checkliste = checkliste ?? _defaultCheckliste(),
        rcdMessungen = rcdMessungen ?? [];

  static List<ChecklistItem> _defaultCheckliste() => [
        ChecklistItem(bezeichnung: 'PE Niederohmigkeit an Klemmleisten prüfen', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Schutzmaßnahmen', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Kennzeichnung der Schutzleiteranschlußstellen', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Verdrahtungsprüfung', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Isolationsprüfung', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Elektrische Funktionsprüfung', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Messgeräte eingestellt, Zählerstände notiert und dokumentiert', kategorie: 'Elektrische Prüfungen'),
        ChecklistItem(bezeichnung: 'Schutzart, Dichtungen und Abdeckungen', kategorie: 'Mechanik & Montage'),
        ChecklistItem(bezeichnung: 'Einstellungen Motorschutzschalter / Motorleistung mit MSR-Liste abgleichen', kategorie: 'Mechanik & Montage'),
        ChecklistItem(bezeichnung: 'Einbaugeräte, Montage, Sitz und Lage', kategorie: 'Mechanik & Montage'),
        ChecklistItem(bezeichnung: 'Funktionstüchtigkeit von Betätigungselementen', kategorie: 'Mechanik & Montage'),
        ChecklistItem(bezeichnung: 'Schraubverbindungen, Festsitz', kategorie: 'Mechanik & Montage'),
        ChecklistItem(bezeichnung: 'Leitungsverlegung, Druckstellen und Kanten', kategorie: 'Mechanik & Montage'),
        ChecklistItem(bezeichnung: 'Stromkreiskennzeichnung (BMK)', kategorie: 'Dokumentation'),
        ChecklistItem(bezeichnung: 'Schaltanlage allseitig fotografiert (allseitig geschlossen, allseitig offen, Detailbilder)', kategorie: 'Dokumentation'),
        ChecklistItem(bezeichnung: 'Typenschilder aufgeklebt', kategorie: 'Dokumentation'),
        ChecklistItem(bezeichnung: 'Betriebs- und Bedienungsanleitungen der Betriebsmittel', kategorie: 'Dokumentation'),
        ChecklistItem(bezeichnung: 'Schaltplantasche inkl. Schaltplan', kategorie: 'Dokumentation'),
        ChecklistItem(bezeichnung: 'Gerätebestückung aufgenommen, dokumentiert', kategorie: 'Dokumentation'),
        ChecklistItem(bezeichnung: 'Rauchmelder geprüft (Spray)', kategorie: 'Sicherheit & Funktion'),
        ChecklistItem(bezeichnung: 'Prüfung der Busteilnehmer', kategorie: 'Sicherheit & Funktion'),
        ChecklistItem(bezeichnung: 'Not-Aus Wirksamkeit geprüft', kategorie: 'Sicherheit & Funktion'),
        ChecklistItem(bezeichnung: 'E/A Test durchgeführt (mit Programmierer)', kategorie: 'Sicherheit & Funktion'),
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'auftragsnummer': auftragsnummer,
        'schrankId': schrankId,
        'ersteller': ersteller,
        'datum': datum.toIso8601String(),
        'checkliste': checkliste.map((e) => e.toJson()).toList(),
        'rcdMessungen': rcdMessungen.map((e) => e.toJson()).toList(),
        'bemerkungen': bemerkungen,
        'freigegeben': freigegeben,
        'unterschriftBase64': unterschriftBase64,
        'status': status.index,
      };

  factory Protokoll.fromJson(Map<String, dynamic> json) => Protokoll(
        id: json['id'] as String,
        auftragsnummer: json['auftragsnummer'] as String? ?? '',
        schrankId: json['schrankId'] as String? ?? '',
        ersteller: json['ersteller'] as String? ?? '',
        datum: DateTime.parse(json['datum'] as String),
        checkliste: (json['checkliste'] as List).map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>)).toList(),
        rcdMessungen: (json['rcdMessungen'] as List).map((e) => RcdMessung.fromJson(e as Map<String, dynamic>)).toList(),
        bemerkungen: json['bemerkungen'] as String? ?? '',
        freigegeben: json['freigegeben'] as bool?,
        unterschriftBase64: json['unterschriftBase64'] as String?,
        status: ProtokollStatus.values[json['status'] as int? ?? 0],
      );

  String toJsonString() => jsonEncode(toJson());

  factory Protokoll.fromJsonString(String s) => Protokoll.fromJson(jsonDecode(s) as Map<String, dynamic>);

  int get bestandenCount => checkliste.where((c) => c.status == PruefStatus.bestanden).length;
  int get durchgefallenCount => checkliste.where((c) => c.status == PruefStatus.durchgefallen).length;
  int get geprueftCount => checkliste.where((c) => c.status != PruefStatus.unset).length;
}
