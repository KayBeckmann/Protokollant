import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/protokoll.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_chip.dart';
import '../protokoll/new_protokoll_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.electric_bolt, color: kPrimary),
        ),
        title: const Text('Protokollant'),
        actions: const [SizedBox(width: 16)],
      ),
      body: provider.protokolle.isEmpty
          ? _buildEmpty(context)
          : _buildList(context, provider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newProtokoll(context),
        tooltip: 'Neues Protokoll',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fact_check_outlined, size: 64, color: kOutline),
          const SizedBox(height: 16),
          Text(
            'Keine Protokolle',
            style: GoogleFonts.ibmPlexSans(fontSize: 20, fontWeight: FontWeight.w600, color: kOnSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Tippe + um ein neues Abnahmeprotokoll anzulegen.',
            style: GoogleFonts.ibmPlexSans(fontSize: 14, color: kOnSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, AppProvider provider) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildStats(provider),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Letzte Protokolle',
              style: GoogleFonts.ibmPlexSans(fontSize: 20, fontWeight: FontWeight.w600, color: kOnSurface),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _ProtokollTile(protokoll: provider.protokolle[i]),
            childCount: provider.protokolle.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 96)),
      ],
    );
  }

  Widget _buildStats(AppProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'In Arbeit',
            count: provider.inArbeitCount,
            icon: Icons.pending_actions,
            iconColor: kSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Abgeschlossen',
            count: provider.abgeschlossenCount,
            icon: Icons.check_circle,
            iconColor: kPrimary,
          ),
        ),
      ],
    );
  }

  void _newProtokoll(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NewProtokollScreen()),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kOutlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                  color: kOnSurfaceVariant,
                ),
              ),
              Icon(icon, color: iconColor, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: GoogleFonts.ibmPlexSans(fontSize: 24, fontWeight: FontWeight.w600, color: kOnSurface),
          ),
          Text(
            'Protokolle',
            style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ProtokollTile extends StatelessWidget {
  final Protokoll protokoll;

  const _ProtokollTile({required this.protokoll});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: kOutlineVariant),
          right: BorderSide(color: kOutlineVariant),
          bottom: BorderSide(color: kOutlineVariant),
          top: context == context ? const BorderSide(color: kOutlineVariant) : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NewProtokollScreen(protokollId: protokoll.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          protokoll.auftragsnummer.isEmpty
                              ? 'Kein Auftrag'
                              : protokoll.auftragsnummer,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kOnSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusChip(status: protokoll.status),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      protokoll.schrankId.isEmpty
                          ? _formatDate(protokoll.datum)
                          : '${protokoll.schrankId} · ${_formatDate(protokoll.datum)}',
                      style: GoogleFonts.ibmPlexSans(fontSize: 13, color: kOnSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kOutline),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}
