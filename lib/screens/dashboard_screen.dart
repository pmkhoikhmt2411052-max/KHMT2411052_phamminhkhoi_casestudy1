import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import 'transaction_form_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> _list = [];
  final _money = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _load(); // mở màn hình là tải dữ liệu ngay
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getAllTransactions();
    if (!mounted) return;
    setState(() => _list = data);
  }

  double get _income => _list
      .where((e) => e.type == 'income')
      .fold(0.0, (sum, e) => sum + e.amount);

  double get _expense => _list
      .where((e) => e.type == 'expense')
      .fold(0.0, (sum, e) => sum + e.amount);

  // Mở form (thêm mới nếu t == null, sửa nếu có t)
  Future<void> _openForm([TransactionModel? t]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => TransactionFormScreen(transaction: t)),
    );
    if (changed == true) _load(); // form báo có thay đổi thì tải lại
  }

  Future<void> _confirmDelete(TransactionModel t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giao dịch'),
        content: Text('Bạn có chắc muốn xóa "${t.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xóa')),
        ],
      ),
    );
    if (ok == true) {
      await DatabaseHelper.instance.deleteTransaction(t.id!);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = _income - _expense;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Số dư'),
                  Text(
                    _money.format(balance),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summary('Thu', _income, Colors.green),
                      _summary('Chi', _expense, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _list.isEmpty
                ? const Center(child: Text('Chưa có giao dịch nào'))
                : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, i) {
                final t = _list[i];
                final isIncome = t.type == 'income';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isIncome ? Colors.green : Colors.red,
                    child: Icon(
                        isIncome
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white),
                  ),
                  title: Text(t.title),
                  subtitle: Text(
                      '${t.category} • ${DateFormat('dd/MM/yyyy').format(DateTime.parse(t.date))}'),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}${_money.format(t.amount)}',
                    style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _openForm(t),
                  onLongPress: () => _confirmDelete(t),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summary(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color)),
        Text(_money.format(value),
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}