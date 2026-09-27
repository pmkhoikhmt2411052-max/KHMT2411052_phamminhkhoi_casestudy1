import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
          builder: (innerContext){
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 240,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Expense Manager',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Quản lý chi tiêu cá nhân\n'
                                  'đơn giản và hiệu quả',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              innerContext,
                              MaterialPageRoute(
                                  builder: (context) => const ExpensePage()
                              ),
                            );
                          },
                          child: const Text('Bắt đầu'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
      ),
    );
  }
}


class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();

  bool isExpense = true;
  String category = 'Ăn uống';
  DateTime selectedDate = DateTime(2025, 4, 12);

  final List<String> categories = [
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Giải trí',
    'Hóa đơn',
    'Khác',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void addExpense() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _noteController.text.isEmpty ? category : _noteController.text,
      amount: isExpense ? -amount : amount,
      category: category,
      date: selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    // TODO: lưu expense

    _noteController.clear();
    _amountController.clear();
    setState(() {
      category = 'Ăn uống';
      selectedDate = DateTime.now();
      isExpense = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu giao dịch')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Chi tiêu / Thu nhập =====
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = true),
                        child: Container(
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isExpense
                                ? const Color(0xFFFF4D6A)
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: Text(
                            'Chi tiêu',
                            style: TextStyle(
                              color: isExpense ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = false),
                        child: Container(
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isExpense
                                ? Colors.green
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: Text(
                            'Thu nhập',
                            style: TextStyle(
                              color: !isExpense ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ===== Danh mục =====
                const Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: category,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      items: categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              if (value == 'Ăn uống') ...[
                                Container(
                                  width: 22,
                                  height: 22,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF4D6A),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => category = newValue);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ===== Số tiền =====
                const Text(
                  'Số tiền',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 15,
                    ),
                    suffixText: 'đ',
                    suffixStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Số tiền không hợp lệ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ===== Ngày giao dịch =====
                const Text(
                  'Ngày giao dịch',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatDate(selectedDate),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Color(0xFF666666),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ===== Ghi chú =====
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú (tùy chọn)',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ===== Nút Lưu =====
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: addExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F6BFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lưu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}