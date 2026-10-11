import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? transaction; // null = thêm mới, có giá trị = sửa
  const TransactionFormScreen({super.key, this.transaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);
  static const _red = Color(0xFFEF4444);

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _type = 'expense';
  String _category = 'Ăn uống';
  DateTime _date = DateTime.now();

  final _expenseCats = ['Ăn uống', 'Đi lại', 'Mua sắm', 'Học tập', 'Khác'];
  final _incomeCats = ['Lương', 'Thưởng', 'Tiền gia đình', 'Khác'];

  List<String> get _cats => _type == 'income' ? _incomeCats : _expenseCats;
  bool get _isEdit => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    if (t != null) {
      _titleCtrl.text = t.title;
      _amountCtrl.text = t.amount.toStringAsFixed(0);
      _noteCtrl.text = t.note;
      _type = t.type;
      _category = t.category;
      _date = DateTime.parse(t.date);
      if (!_cats.contains(_category)) _category = _cats.first;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final t = TransactionModel(
      id: widget.transaction?.id,
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      type: _type,
      category: _category,
      date: _date.toIso8601String(),
      note: _noteCtrl.text.trim(),
    );

    if (_isEdit) {
      await DatabaseHelper.instance.updateTransaction(t);
    } else {
      await DatabaseHelper.instance.insertTransaction(t);
    }
    if (mounted) Navigator.pop(context, true);
  }

  InputDecoration _decoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      suffixIcon: suffix,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _blue, width: 1.5),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
  );

  Widget _typeTab(String value, String label, Color color) {
    final selected = _type == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _type = value;
          _category = _cats.first;
        }),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
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
        title: Text(
          _isEdit ? 'Sửa giao dịch' : 'Thêm giao dịch',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _typeTab('expense', 'Chi tiêu', _red),
                    _typeTab('income', 'Thu nhập', _green),
                  ],
                ),
              ),

              _label('Tiêu đề'),
              TextFormField(
                controller: _titleCtrl,
                decoration: _decoration(hint: 'Nhập tiêu đề'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tiêu đề' : null,
              ),

              _label('Danh mục'),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: _decoration(),
                items: _cats
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),

              _label('Số tiền'),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _decoration(
                  hint: 'Nhập số tiền',
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Align(
                      widthFactor: 1,
                      child: Text('đ',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Số tiền phải lớn hơn 0';
                  return null;
                },
              ),

              _label('Ngày giao dịch'),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: _decoration(
                    suffix: const Icon(Icons.calendar_today_outlined,
                        size: 18, color: Colors.grey),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                ),
              ),

              _label('Ghi chú'),
              TextFormField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: _decoration(hint: 'Nhập ghi chú (tùy chọn)'),
              ),

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _save,
                  child: Text(_isEdit ? 'Cập nhật' : 'Lưu',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}