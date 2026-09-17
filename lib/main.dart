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
      title: 'Expense Manager',
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Phần nội dung ở giữa
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO
                  const WalletLogo(),

                  const SizedBox(height: 20),

                  // TIÊU ĐỀ
                  const Text(
                    'Expense Manager',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14243A),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // MÔ TẢ
                  const Text(
                    'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: Color(0xFF8090A5),
                    ),
                  ),
                ],
              ),
            ),

            // NÚT BẮT ĐẦU
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    // Sau này xử lý khi bấm Bắt đầu ở đây
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F70C8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// LOGO VÍ TIỀN
// ===============================

class WalletLogo extends StatelessWidget {
  const WalletLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phần màu xanh lá phía sau
          Positioned(
            top: 5,
            left: 25,
            child: Container(
              width: 56,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF72C77B),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          // Phần xanh lá nhỏ bên trái
          Positioned(
            top: 14,
            left: 18,
            child: Container(
              width: 17,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF5DBA6A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
            ),
          ),

          // Thân ví màu xanh
          Positioned(
            bottom: 5,
            left: 10,
            child: Container(
              width: 90,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1F78D1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Miếng khóa ví
          Positioned(
            bottom: 22,
            right: 10,
            child: Container(
              width: 35,
              height: 21,
              decoration: BoxDecoration(
                color: const Color(0xFF155DB0),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}