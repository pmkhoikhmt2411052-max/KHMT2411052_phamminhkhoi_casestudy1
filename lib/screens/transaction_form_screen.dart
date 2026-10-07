import 'package:flutter/material.dart';
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
      // Chế độ sửa: điền sẵn dữ liệu cũ vào ô nhập
      _titleCtrl.text = t.title;
      _amountCtrl.text = t.amount.toStringAsFixed(0);
      _noteCtrl.text = t.note;
      _type = t.type;
      _category = t.category;
      _date = DateTime.parse(t.date);
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
    if (!_formKey.currentState!.validate()) return; // kiểm tra nhập đúng chưa

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
    if (mounted) Navigator.pop(context, true); // báo Dashboard: "load lại đi"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Sửa giao dịch' : 'Thêm giao dịch')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Chi')),
                  ButtonSegment(value: 'income', label: Text('Thu')),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() {
                  _type = s.first;
                  _category = _cats.first;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                    labelText: 'Tiêu đề', border: OutlineInputBorder()),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nhập tiêu đề' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Số tiền', border: OutlineInputBorder()),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Số tiền phải lớn hơn 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                    labelText: 'Danh mục', border: OutlineInputBorder()),
                items: _cats
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Ngày', border: OutlineInputBorder()),
                  child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Ghi chú', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(_isEdit ? 'Cập nhật' : 'Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}