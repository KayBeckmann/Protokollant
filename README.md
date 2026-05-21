# Protokollant

Digitale Schaltschrank-Abnahme mit PDF-Export für Android.

Ersetzt das handausgefüllte Abnahmeprotokoll (Papier → Scan → ERP) durch eine strukturierte digitale Erfassung.

## Features

- **Checkliste** — 23 Abnahmepunkte in 4 Kategorien (Tristate: Bestanden / Durchgefallen / N/A)
- **RCD-Messungen** — Auslösezeit (ms) und Auslösestrom (mA) je FI/RCD
- **Digitale Unterschrift** — Signature-Pad mit Zeitstempel
- **PDF-Export** — DIN A4, Seite 1: Protokoll + Unterschrift, Seite 2: RCD-Tabelle
- **Ersteller-Dropdown** — konfigurierbare Kollegen-Liste in Einstellungen
- **Prüfer** — fest in Einstellungen hinterlegt
- **Freigabe-Toggle** — Schrank freigegeben / nicht freigegeben
- **Lokale Persistenz** — alle Protokolle bleiben nach App-Neustart erhalten

## Design

Industrial Precision System — IBM Plex Sans, Marine-Blau (#003461), optimiert für Feldarbeit unter wechselnden Lichtverhältnissen.

## Stack

| Was | Womit |
|-----|-------|
| Framework | Flutter 3.x (Android-only) |
| Persistenz | Hive (JSON in `Box<String>`) |
| State | Provider |
| PDF | pdf + printing |
| Unterschrift | signature |
| Fonts | google_fonts (IBM Plex Sans) |

## Roadmap

| Meilenstein | Status |
|-------------|--------|
| M1: Projektgrundgerüst | ✅ |
| M2: Datenmodelle & Persistenz | ✅ |
| M3: Dashboard | ✅ |
| M4: Checkliste | ✅ |
| M5: RCD-Messungen | ✅ |
| M6: Abschluss & Unterschrift | ✅ |
| M7: PDF-Export | ✅ |
| M8: Einstellungen | ✅ |

## Abnahmepunkte

### Elektrische Prüfungen
PE Niederohmigkeit · Schutzmaßnahmen · Kennzeichnung Schutzleiteranschlußstellen · Verdrahtungsprüfung · Isolationsprüfung · Elektrische Funktionsprüfung · Messgeräte

### Mechanik & Montage
Schutzart/Dichtungen · Motorschutzschalter/MSR · Einbaugeräte · Betätigungselemente · Schraubverbindungen · Leitungsverlegung

### Dokumentation
Stromkreiskennzeichnung (BMK) · Fotos · Typenschilder · BA/Bedienungsanleitungen · Schaltplantasche · Gerätebestückung

### Sicherheit & Funktion
Rauchmelder · Busteilnehmer · Not-Aus · E/A Test

## Lizenz

MIT — siehe [LICENSE](LICENSE)
