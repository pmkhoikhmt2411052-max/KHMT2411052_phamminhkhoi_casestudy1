import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  static const _blue = Color(0xFF2563EB);
  static const _palette = [
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
    Color(0xFFEC4899),
    Color(0xFF6B7280),
  ];

  List<TransactionModel> _all = [];
  int _tab = 0; // 0 tháng này, 1 tháng trước, 2 năm nay
  final _money = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getAllTransactions();
    if (!mounted) return;
    setState(() => _all = data);
  }

  bool _inRange(DateTime d) {
    final now = DateTime.now();
    switch (_tab) {
      case 0:
        return d.year == now.year && d.month == now.month;
      case 1:
        final prev = DateTime(now.year, now.month - 1);
        return d.year == prev.year && d.month == prev.month;
      default:
        return d.year == now.year;
    }
  }

  List<TransactionModel> get _inPeriod =>
      _all.where((t) => _inRange(DateTime.parse(t.date))).toList();

  @override
  Widget build(BuildContext context) {
    final period = _inPeriod;
    final income = period
        .where((t) => t.type == 'income')
        .fold(0.0, (s, t) => s + t.amount);
    final expenses = period.where((t) => t.type == 'expense').toList();
    final expense = expenses.fold(0.0, (s, t) => s + t.amount);

    final byCat = <String, double>{};
    for (final t in expenses) {
      byCat[t.category] = (byCat[t.category] ?? 0) + t.amount;
    }
    final entries = byCat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Thống kê',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _periodTab('Tháng này', 0),
                  _periodTab('Tháng trước', 1),
                  _periodTab('Năm nay', 2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(200, 200),
                      painter: _DonutPainter(
                        entries.map((e) => e.value).toList(),
                        List.generate(entries.length,
                                (i) => _palette[i % _palette.length]),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_money.format(expense),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const Text('Tổng chi tiêu',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _summary('Thu nhập', income, const Color(0xFF22C55E),
                        const Color(0xFFDCFCE7))),
                const SizedBox(width: 12),
                Expanded(
                    child: _summary('Chi tiêu', expense,
                        const Color(0xFFEF4444), const Color(0xFFFEE2E2))),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Chi tiêu theo danh mục',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: Text('Chưa có chi tiêu trong kỳ này')),
              )
            else
              ...List.generate(entries.length, (i) {
                final e = entries[i];
                final percent = expense == 0 ? 0 : e.value / expense * 100;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _palette[i % _palette.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(e.key,
                            style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Text('${percent.toStringAsFixed(1)}%',
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 12),
                      Text(_money.format(e.value),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _periodTab(String label, int index) {
    final selected = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _blue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _summary(String label, double value, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(_money.format(value),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  _DonutPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 28.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final total = values.fold(0.0, (a, b) => a + b);
    if (total <= 0) {
      paint.color = const Color(0xFFE5E7EB);
      canvas.drawArc(arcRect, 0, math.pi * 2, false, paint);
      return;
    }

    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * math.pi * 2;
      paint.color = colors[i];
      canvas.drawArc(arcRect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.values != values || old.colors != colors;
}