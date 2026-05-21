import 'dart:convert';

class AppSettings {
  String prueferName;
  List<String> erstellerListe;

  AppSettings({
    this.prueferName = '',
    List<String>? erstellerListe,
  }) : erstellerListe = erstellerListe ?? [];

  Map<String, dynamic> toJson() => {
        'prueferName': prueferName,
        'erstellerListe': erstellerListe,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        prueferName: json['prueferName'] as String? ?? '',
        erstellerListe: (json['erstellerListe'] as List?)?.map((e) => e as String).toList() ?? [],
      );

  String toJsonString() => jsonEncode(toJson());

  factory AppSettings.fromJsonString(String s) =>
      AppSettings.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
