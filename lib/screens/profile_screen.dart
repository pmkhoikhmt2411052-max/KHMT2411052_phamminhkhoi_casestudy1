import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Lưu tạm trong bộ nhớ (mất khi tắt app)
String _userName = 'Nguyễn Văn A';
String _userEmail = 'nguyenvana@example.com';
double _budget = 0;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _blue = Color(0xFF2563EB);
  final _money = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  Future<void> _editInfo() async {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thông tin cá nhân'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Họ tên'),
            ),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Lưu')),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        if (nameCtrl.text.trim().isNotEmpty) _userName = nameCtrl.text.trim();
        _userEmail = emailCtrl.text.trim();
      });
    }
  }

  Future<void> _editBudget() async {
    final ctrl = TextEditingController(
        text: _budget > 0 ? _budget.toStringAsFixed(0) : '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ngân sách tháng'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
              labelText: 'Số tiền', suffixText: 'đ'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Lưu')),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _budget = double.tryParse(ctrl.text) ?? 0);
    }
  }

  Widget _item(IconData icon, String title, String? sub, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFDBEAFE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _blue, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: sub == null
          ? null
          : Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
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
        title: const Text('Cá nhân',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFDBEAFE),
                  child: Icon(Icons.person, color: _blue, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_userName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(_userEmail,
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _item(Icons.person_outline, 'Thông tin cá nhân', null, _editInfo),
          _item(
            Icons.savings_outlined,
            'Cài đặt ngân sách',
            _budget > 0 ? _money.format(_budget) : 'Chưa đặt',
            _editBudget,
          ),
          _item(Icons.info_outline, 'Về ứng dụng', 'Expense Manager 1.0', () {
            showAboutDialog(
              context: context,
              applicationName: 'Expense Manager',
              applicationVersion: '1.0',
              children: const [
                Text('Quản lý chi tiêu cá nhân đơn giản và hiệu quả.'),
              ],
            );
          }),
        ],
      ),
    );
  }
}