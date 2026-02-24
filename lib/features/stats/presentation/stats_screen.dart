import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/network/sync_coordinator.dart';
import 'stats_providers.dart';

class StatsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/stats';

  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  late int _year;
  late int _month;
  StatsPeriod _period = StatsPeriod.all;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _refreshStats();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshStats();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = StatsFilter(period: _period, year: _year, month: _month);
    final stats = ref.watch(statsSummaryProvider(filter));

    return AppScaffold(
      title: l10n.statsTitle,
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshStats,
        tooltip: l10n.syncNow,
        child: const Icon(Icons.refresh),
      ),
      body: stats.when(
        data: (s) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildFilters(context, l10n),
              const SizedBox(height: 12),
              _SectionTitle(text: l10n.sessionsStats),
              const SizedBox(height: 8),
              _MetricCard(
                title: l10n.totalSessions,
                value: s.totalSessions.toString(),
                color: const Color(0xFF0B6E8A),
              ),
              _MetricCard(
                title: l10n.sessionsMale,
                value: s.sessionsMale.toString(),
                color: const Color(0xFF1565C0),
              ),
              _MetricCard(
                title: l10n.sessionsFemale,
                value: s.sessionsFemale.toString(),
                color: const Color(0xFFAD1457),
              ),
              _MetricCard(
                title: l10n.sessionsChild,
                value: s.sessionsChild.toString(),
                color: const Color(0xFFE65100),
              ),
              const SizedBox(height: 12),
              _PieCard(
                title: l10n.sessionsRatio,
                total: s.totalSessions,
                male: s.sessionsMale,
                female: s.sessionsFemale,
                child: s.sessionsChild,
              ),
              const SizedBox(height: 20),
              _SectionTitle(text: l10n.patientsStats),
              const SizedBox(height: 8),
              _MetricCard(
                title: l10n.totalPatients,
                value: s.totalPatients.toString(),
                color: const Color(0xFF2BBFA4),
              ),
              _MetricCard(
                title: l10n.currentlyTreating,
                value: s.activePatients.toString(),
                color: const Color(0xFF2E7D32),
              ),
              _MetricCard(
                title: l10n.finishedTreatment,
                value: s.completedPatients.toString(),
                color: const Color(0xFF0B6E8A),
              ),
              _MetricCard(
                title: l10n.patientsMale,
                value: s.patientsMale.toString(),
                color: const Color(0xFF1565C0),
              ),
              _MetricCard(
                title: l10n.patientsFemale,
                value: s.patientsFemale.toString(),
                color: const Color(0xFFAD1457),
              ),
              _MetricCard(
                title: l10n.patientsChild,
                value: s.patientsChild.toString(),
                color: const Color(0xFFE65100),
              ),
              const SizedBox(height: 12),
              _PieCard(
                title: l10n.patientsRatio,
                total: s.totalPatients,
                male: s.patientsMale,
                female: s.patientsFemale,
                child: s.patientsChild,
              ),
              const SizedBox(height: 20),
              _SectionTitle(text: l10n.statsByTherapist),
              const SizedBox(height: 8),
              if (s.byTherapist.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.noResults),
                  ),
                ),
              ...s.byTherapist.map(
                (t) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.therapistName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _MiniStat(
                              label: l10n.totalPatients,
                              value: t.totalPatients.toString(),
                            ),
                            _MiniStat(
                              label: l10n.patientsMale,
                              value: t.patientsMale.toString(),
                            ),
                            _MiniStat(
                              label: l10n.patientsFemale,
                              value: t.patientsFemale.toString(),
                            ),
                            _MiniStat(
                              label: l10n.patientsChild,
                              value: t.patientsChild.toString(),
                            ),
                            _MiniStat(
                              label: l10n.currentlyTreating,
                              value: t.activePatients.toString(),
                            ),
                            _MiniStat(
                              label: l10n.finishedTreatment,
                              value: t.completedPatients.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l10n.statsLoadFailed(e.toString()))),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, AppLocalizations l10n) {
    final years = <int>[for (int y = DateTime.now().year; y >= 2020; y--) y];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.monthly),
                  selected: _period == StatsPeriod.month,
                  onSelected: (_) =>
                      setState(() => _period = StatsPeriod.month),
                ),
                ChoiceChip(
                  label: Text(l10n.yearly),
                  selected: _period == StatsPeriod.year,
                  onSelected: (_) => setState(() => _period = StatsPeriod.year),
                ),
                ChoiceChip(
                  label: Text(l10n.overall),
                  selected: _period == StatsPeriod.all,
                  onSelected: (_) => setState(() => _period = StatsPeriod.all),
                ),
              ],
            ),
            if (_period != StatsPeriod.all) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _year,
                      items: years
                          .map(
                            (y) => DropdownMenuItem<int>(
                              value: y,
                              child: Text('$y'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _year = v ?? _year),
                      decoration: InputDecoration(labelText: l10n.yearLabel),
                    ),
                  ),
                  if (_period == StatsPeriod.month) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _month,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('01')),
                          DropdownMenuItem(value: 2, child: Text('02')),
                          DropdownMenuItem(value: 3, child: Text('03')),
                          DropdownMenuItem(value: 4, child: Text('04')),
                          DropdownMenuItem(value: 5, child: Text('05')),
                          DropdownMenuItem(value: 6, child: Text('06')),
                          DropdownMenuItem(value: 7, child: Text('07')),
                          DropdownMenuItem(value: 8, child: Text('08')),
                          DropdownMenuItem(value: 9, child: Text('09')),
                          DropdownMenuItem(value: 10, child: Text('10')),
                          DropdownMenuItem(value: 11, child: Text('11')),
                          DropdownMenuItem(value: 12, child: Text('12')),
                        ],
                        onChanged: (v) => setState(() => _month = v ?? _month),
                        decoration: InputDecoration(labelText: l10n.monthLabel),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _refreshStats() async {
    await SyncCoordinator.instance.syncNow();
    final filter = StatsFilter(period: _period, year: _year, month: _month);
    ref.invalidate(statsSummaryProvider(filter));
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('$label: $value'),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF0B6E8A),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1A2B35),
              ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _MetricCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.06),
              Colors.white,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(Icons.insert_chart_outlined, color: color, size: 20),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _PieCard extends StatelessWidget {
  final String title;
  final int total;
  final int male;
  final int female;
  final int child;

  const _PieCard({
    required this.title,
    required this.total,
    required this.male,
    required this.female,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slices = <_Slice>[
      _Slice(label: l10n.male, value: male, color: Colors.blue),
      _Slice(label: l10n.female, value: female, color: Colors.pink),
      _Slice(label: l10n.child, value: child, color: Colors.orange),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: _PiePainter(slices: slices, total: total),
                      child: Center(
                        child: Text(
                          l10n.totalLabel(total.toString()),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: slices.map((s) {
                        final percent = total == 0
                            ? 0
                            : ((s.value / total) * 100).round();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: s.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.label,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Text(
                                '${s.value} ($percent%)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slice {
  final String label;
  final int value;
  final Color color;
  const _Slice({required this.label, required this.value, required this.color});
}

class _PiePainter extends CustomPainter {
  final List<_Slice> slices;
  final int total;

  _PiePainter({required this.slices, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (total <= 0) {
      final p = Paint()..color = Colors.grey.shade300;
      canvas.drawCircle(center, radius, p);
      return;
    }

    var start = -90.0;
    for (final s in slices) {
      if (s.value <= 0) continue;
      final sweep = 360.0 * (s.value / total);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = s.color;
      canvas.drawArc(rect, _degToRad(start), _degToRad(sweep), true, paint);
      start += sweep;
    }

    final hole = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.45, hole);
  }

  double _degToRad(double d) => d * 3.1415926535897932 / 180.0;

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.total != total || oldDelegate.slices != slices;
  }
}
