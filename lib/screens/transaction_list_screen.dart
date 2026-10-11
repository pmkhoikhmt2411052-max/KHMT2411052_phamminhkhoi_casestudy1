import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import 'filter_screen.dart';
import 'transaction_form_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);
  static const _red = Color(0xFFEF4444);

  List<TransactionModel> _all = [];
  String _search = '';
  int _tab = 0; // 0 tất cả, 1 thu nhập, 2 chi tiêu
  FilterOptions _filter = const FilterOptions();
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

  List<TransactionModel> get _shown {
    return _all.where((t) {
      if (_tab == 1 && t.type != 'income') return false;
      if (_tab == 2 && t.type != 'expense') return false;
      if (!_filter.matches(t)) return false;
      if (_search.isNotEmpty &&
          !t.title.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _openFilter() async {
    final result = await Navigator.push<FilterOptions>(
      context,
      MaterialPageRoute(builder: (_) => FilterScreen(initial: _filter)),
    );
    if (result != null) setState(() => _filter = result);
  }

  Future<void> _openForm([TransactionModel? t]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => TransactionFormScreen(transaction: t)),
    );
    if (changed == true) _load();
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

  IconData _icon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Mua sắm':
        return Icons.shopping_cart;
      case 'Lương':
        return Icons.account_balance_wallet;
      case 'Đi lại':
        return Icons.directions_car;
      case 'Học tập':
        return Icons.school;
      case 'Thưởng':
        return Icons.card_giftcard;
      case 'Tiền gia đình':
        return Icons.family_restroom;
      default:
        return Icons.category;
    }
  }

  Widget _tabChip(String label, int index) {
    final selected = _tab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: _blue,
        backgroundColor: const Color(0xFFF3F4F6),
        side: BorderSide.none,
        labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black87, fontSize: 13),
        onSelected: (_) => setState(() => _tab = index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _shown;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Giao dịch',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v.trim()),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm giao dịch...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: !_filter.isEmpty,
                  smallSize: 9,
                  child: IconButton(
                    onPressed: _openFilter,
                    icon: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tabChip('Tất cả', 0),
                _tabChip('Thu nhập', 1),
                _tabChip('Chi tiêu', 2),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Không có giao dịch nào'))
                : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final t = items[i];
                  final isIncome = t.type == 'income';
                  final color = isIncome ? _green : _red;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openForm(t),
                    onLongPress: () => _confirmDelete(t),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(_icon(t.category),
                                color: color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(t.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(
                                  '${t.category} • ${DateFormat('dd/MM/yyyy').format(DateTime.parse(t.date))}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isIncome ? '+' : '-'}${_money.format(t.amount)}',
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _blue,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}