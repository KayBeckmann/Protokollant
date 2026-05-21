import 'pruf_status.dart';

class ChecklistItem {
  String bezeichnung;
  String kategorie;
  PruefStatus status;

  ChecklistItem({
    required this.bezeichnung,
    required this.kategorie,
    this.status = PruefStatus.unset,
  });

  Map<String, dynamic> toJson() => {
        'bezeichnung': bezeichnung,
        'kategorie': kategorie,
        'status': status.index,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        bezeichnung: json['bezeichnung'] as String,
        kategorie: json['kategorie'] as String,
        status: PruefStatus.values[json['status'] as int? ?? 0],
      );
}
