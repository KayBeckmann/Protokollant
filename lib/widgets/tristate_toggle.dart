import 'package:flutter/material.dart';
import '../models/pruf_status.dart';
import '../theme/app_theme.dart';

class TristateToggle extends StatelessWidget {
  final PruefStatus value;
  final ValueChanged<PruefStatus> onChanged;
  final bool compact;

  const TristateToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 40 : 48,
      decoration: BoxDecoration(
        border: Border.all(color: kOutlineVariant),
        borderRadius: BorderRadius.circular(4),
        color: kSurfaceContainerLow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToggleButton(
              label: '✓',
              isActive: value == PruefStatus.bestanden,
              activeColor: kSuccess,
              activeTextColor: Colors.white,
              onTap: () => onChanged(PruefStatus.bestanden),
              compact: compact,
              borderRight: true,
            ),
            _ToggleButton(
              label: '✕',
              isActive: value == PruefStatus.durchgefallen,
              activeColor: kError,
              activeTextColor: Colors.white,
              onTap: () => onChanged(PruefStatus.durchgefallen),
              compact: compact,
              borderRight: true,
            ),
            _ToggleButton(
              label: 'N/A',
              isActive: value == PruefStatus.na,
              activeColor: kSurfaceVariant,
              activeTextColor: kOnSurfaceVariant,
              onTap: () => onChanged(PruefStatus.na),
              compact: compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color activeTextColor;
  final VoidCallback onTap;
  final bool compact;
  final bool borderRight;

  const _ToggleButton({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.activeTextColor,
    required this.onTap,
    this.compact = false,
    this.borderRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: compact ? 44 : 56,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          border: borderRight ? const Border(right: BorderSide(color: kOutlineVariant)) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: compact ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: isActive ? activeTextColor : kSecondary,
          ),
        ),
      ),
    );
  }
}
