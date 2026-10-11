import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_shell.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý chi tiêu',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2878E8),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý giao dịch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Thêm giao dịch'),
            ),

            const SizedBox(width: 20,height: 20,),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditTransactionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Sửa giao dịch'),
            ),

            const SizedBox(height: 20),

            // ===== NÚT DASHBOARD MỚI =====
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeShell(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Dashboard'),
            )
          ],
        ),
      ),
    );
  }
}
class TransactionForm extends StatefulWidget {
  final bool isEdit;

  const TransactionForm({
    super.key,
    required this.isEdit,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isExpense = true;

  String category = 'Ăn uống';

  DateTime selectedDate = DateTime(2025, 4, 12);

  final TextEditingController amountController =
  TextEditingController();

  final TextEditingController noteController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    // Nếu là màn hình Sửa giao dịch
    if (widget.isEdit) {
      amountController.text = '100.000';
      noteController.text = 'Ăn trưa';
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFF18243A),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.isEdit ? 'Sửa giao dịch' : 'Thêm giao dịch',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF18243A),
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // CHI TIÊU / THU NHẬP
              // =========================

              buildTypeSelector(),

              const SizedBox(height: 20),

              // =========================
              // DANH MỤC
              // =========================

              buildLabel('Danh mục'),

              const SizedBox(height: 7),

              buildCategoryDropdown(),

              const SizedBox(height: 20),

              // =========================
              // SỐ TIỀN
              // =========================

              buildLabel('Số tiền'),

              const SizedBox(height: 7),

              buildAmountField(),

              const SizedBox(height: 20),

              // =========================
              // NGÀY GIAO DỊCH
              // =========================

              buildLabel('Ngày giao dịch'),

              const SizedBox(height: 7),

              buildDateField(),

              const SizedBox(height: 20),

              // =========================
              // GHI CHÚ
              // =========================

              buildLabel('Ghi chú'),

              const SizedBox(height: 7),

              buildNoteField(),

              const SizedBox(height: 24),

              // =========================
              // BUTTON LƯU
              // =========================

              buildSaveButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // LABEL
  // =========================================================

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF18243A),
      ),
    );
  }

  // =========================================================
  // CHI TIÊU / THU NHẬP
  // =========================================================

  Widget buildTypeSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE1E5EB),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isExpense
                      ? const Color(0xFFFF6268)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Chi tiêu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isExpense
                        ? Colors.white
                        : const Color(0xFF18243A),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !isExpense
                      ? const Color(0xFF3B82F6)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Thu nhập',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: !isExpense
                        ? Colors.white
                        : const Color(0xFF18243A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DANH MỤC
  // =========================================================

  Widget buildCategoryDropdown() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFDDE3EA),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: category,
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF687386),
          ),

          items: const [
            DropdownMenuItem(
              value: 'Ăn uống',
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 17,
                    color: Color(0xFFFF6268),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Ăn uống',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Di chuyển',
              child: Text(
                'Di chuyển',
                style: TextStyle(fontSize: 13),
              ),
            ),

            DropdownMenuItem(
              value: 'Mua sắm',
              child: Text(
                'Mua sắm',
                style: TextStyle(fontSize: 13),
              ),
            ),

            DropdownMenuItem(
              value: 'Học tập',
              child: Text(
                'Học tập',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],

          onChanged: (value) {
            if (value != null) {
              setState(() {
                category = value;
              });
            }
          },
        ),
      ),
    );
  }

  // =========================================================
  // SỐ TIỀN
  // =========================================================

  Widget buildAmountField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,

      decoration: InputDecoration(
        hintText: 'Nhập số tiền',
        hintStyle: const TextStyle(
          color: Color(0xFFB0B8C4),
          fontSize: 12,
        ),

        suffixText: 'đ',
        suffixStyle: const TextStyle(
          color: Color(0xFF687386),
          fontSize: 12,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFDDE3EA),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFDDE3EA),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFF2878E8),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // NGÀY
  // =========================================================

  Widget buildDateField() {
    return GestureDetector(
      onTap: selectDate,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFDDE3EA),
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(
                formatDate(selectedDate),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3E4A5C),
                ),
              ),
            ),

            const Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: Color(0xFF687386),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // GHI CHÚ
  // =========================================================

  Widget buildNoteField() {
    return TextField(
      controller: noteController,
      maxLines: 3,

      decoration: InputDecoration(
        hintText: 'Nhập ghi chú (tùy chọn)',
        hintStyle: const TextStyle(
          color: Color(0xFFB0B8C4),
          fontSize: 12,
        ),

        contentPadding: const EdgeInsets.all(12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFDDE3EA),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFFDDE3EA),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(0xFF2878E8),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // BUTTON LƯU
  // =========================================================

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,

      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã lưu giao dịch'),
            ),
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2878E8),
          foregroundColor: Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),

        child: const Text(
          'Lưu',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionForm(
      isEdit: false,
    );
  }
}
class EditTransactionScreen extends StatelessWidget {
  const EditTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionForm(
      isEdit: true,
    );
  }
}