import 'pruf_status.dart';

class RcdMessung {
  String name;
  double? ausloesezeit; // ms
  double? ausloesestrom; // mA
  PruefStatus status;

  RcdMessung({
    this.name = '',
    this.ausloesezeit,
    this.ausloesestrom,
    this.status = PruefStatus.unset,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'ausloesezeit': ausloesezeit,
        'ausloesestrom': ausloesestrom,
        'status': status.index,
      };

  factory RcdMessung.fromJson(Map<String, dynamic> json) => RcdMessung(
        name: json['name'] as String? ?? '',
        ausloesezeit: (json['ausloesezeit'] as num?)?.toDouble(),
        ausloesestrom: (json['ausloesestrom'] as num?)?.toDouble(),
        status: PruefStatus.values[json['status'] as int? ?? 0],
      );
}
