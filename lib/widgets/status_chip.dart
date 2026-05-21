import 'package:flutter/material.dart';
import '../models/protokoll.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final ProtokollStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String label;

    switch (status) {
      case ProtokollStatus.neu:
        bg = kSurfaceContainerHigh;
        fg = kOnSurfaceVariant;
        label = 'Neu';
      case ProtokollStatus.inArbeit:
        bg = kSecondaryContainer;
        fg = kOnSecondaryContainer;
        label = 'In Arbeit';
      case ProtokollStatus.abgeschlossen:
        bg = const Color(0xFFd4edda);
        fg = const Color(0xFF155724);
        label = 'Abgeschlossen';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
          color: fg,
        ),
      ),
    );
  }
}
