import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class FilterOptions {
  final Set<String> types; // 'income' / 'expense'
  final Set<String> categories;
  const FilterOptions({this.types = const {}, this.categories = const {}});

  bool get isEmpty => types.isEmpty && categories.isEmpty;

  bool matches(TransactionModel t) =>
      (types.isEmpty || types.contains(t.type)) &&
          (categories.isEmpty || categories.contains(t.category));
}

class FilterScreen extends StatefulWidget {
  final FilterOptions initial;
  const FilterScreen({super.key, this.initial = const FilterOptions()});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const _blue = Color(0xFF2563EB);

  static const _allCategories = [
    'Ăn uống',
    'Đi lại',
    'Mua sắm',
    'Học tập',
    'Lương',
    'Thưởng',
    'Tiền gia đình',
    'Khác',
  ];

  late Set<String> _types;
  late Set<String> _cats;

  @override
  void initState() {
    super.initState();
    _types = {...widget.initial.types};
    _cats = {...widget.initial.categories};
  }

  void _toggleType(String v) {
    setState(() {
      if (!_types.remove(v)) _types.add(v);
      if (_types.length == 2) _types.clear();
    });
  }

  void _toggleCat(String v) {
    setState(() {
      if (!_cats.remove(v)) _cats.add(v);
    });
  }

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 4),
    child: Text(text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
  );

  Widget _check(String label, bool value, VoidCallback onTap) {
    return CheckboxListTile(
      value: value,
      onChanged: (_) => onTap(),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      activeColor: _blue,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Bộ lọc',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _title('Loại giao dịch'),
          _check('Tất cả', _types.isEmpty, () => setState(_types.clear)),
          _check('Thu nhập', _types.contains('income'),
                  () => _toggleType('income')),
          _check('Chi tiêu', _types.contains('expense'),
                  () => _toggleType('expense')),
          _title('Danh mục'),
          _check('Tất cả', _cats.isEmpty, () => setState(_cats.clear)),
          ..._allCategories
              .map((c) => _check(c, _cats.contains(c), () => _toggleCat(c))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => setState(() {
                      _types.clear();
                      _cats.clear();
                    }),
                    child: const Text('Đặt lại'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(
                        context, FilterOptions(types: _types, categories: _cats)),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}