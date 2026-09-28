import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // =========================
      // BODY
      // =========================

      body: SafeArea(
        child: Column(
          children: [

            // Phần nội dung có thể scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 8),

                    // HEADER
                    _buildHeader(),

                    const SizedBox(height: 14),

                    // SỐ DƯ
                    _buildBalanceCard(),

                    const SizedBox(height: 9),

                    // THU + CHI
                    _buildIncomeExpense(),

                    const SizedBox(height: 16),

                    // GIAO DỊCH GẦN ĐÂY
                    _buildRecentTitle(),

                    const SizedBox(height: 7),

                    // DANH SÁCH GIAO DỊCH
                    _buildTransactionList(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // NÚT +
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Mở màn hình thêm giao dịch
        },
        backgroundColor: const Color(0xFF2878E8),
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      // THANH ĐIỀU HƯỚNG
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Row(
      children: [

        // MENU
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.menu,
            size: 21,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(width: 17),

        const Expanded(
          child: Text(
            'Quản lý thu chi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
        ),

        // THÔNG BÁO
        Stack(
          clipBehavior: Clip.none,
          children: [

            IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.notifications_none_outlined,
                size: 22,
                color: Color(0xFF172033),
              ),
            ),

            Positioned(
              right: -1,
              top: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // SỐ DƯ
  // =========================================================

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      height: 108,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4A8AF5),
            Color(0xFF1761DA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Stack(
        children: [

          // Tiền minh họa
          Positioned(
            right: 10,
            bottom: 7,
            child: Icon(
              Icons.account_balance_wallet,
              size: 49,
              color: Colors.white.withOpacity(0.55),
            ),
          ),

          Positioned(
            right: 43,
            bottom: 7,
            child: Icon(
              Icons.monetization_on,
              size: 30,
              color: Colors.amber,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [

                  Text(
                    'SỐ DƯ HIỆN TẠI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(width: 7),

                  Icon(
                    Icons.visibility_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              const Text(
                '5.000.000 đ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Dấu slide
          Positioned(
            bottom: 7,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: 9,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(width: 4),

                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 4),

                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // THU + CHI
  // =========================================================

  Widget _buildIncomeExpense() {
    return Row(
      children: [

        Expanded(
          child: _buildMoneyCard(
            title: 'TỔNG THU NHẬP',
            amount: '8.000.000 đ',
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF42B866),
            backgroundColor: const Color(0xFFEAF8EC),
            amountColor: const Color(0xFF21A642),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildMoneyCard(
            title: 'TỔNG CHI TIÊU',
            amount: '3.000.000 đ',
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFFFF5862),
            backgroundColor: const Color(0xFFFFECEE),
            amountColor: const Color(0xFFFF3D49),
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color amountColor,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),

      child: Row(
        children: [

          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15,
              color: iconColor,
            ),
          ),

          const SizedBox(width: 7),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 7,
                  color: Color(0xFF667085),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                amount,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TITLE GIAO DỊCH
  // =========================================================

  Widget _buildRecentTitle() {
    return Row(
      children: [

        const Expanded(
          child: Text(
            'Giao dịch gần đây',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
        ),

        GestureDetector(
          onTap: () {},
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF2878E8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // DANH SÁCH
  // =========================================================

  Widget _buildTransactionList() {
    final transactions = [
      {
        'title': 'Ăn trưa',
        'category': 'Ăn uống',
        'date': '03/09/2024',
        'amount': '-50.000 đ',
        'icon': Icons.restaurant,
        'color': const Color(0xFFFF792E),
        'isIncome': false,
      },
      {
        'title': 'Xăng xe',
        'category': 'Di chuyển',
        'date': '03/09/2024',
        'amount': '-100.000 đ',
        'icon': Icons.directions_car,
        'color': const Color(0xFF168BF5),
        'isIncome': false,
      },
      {
        'title': 'Lương tháng 9',
        'category': 'Thu nhập',
        'date': '01/09/2024',
        'amount': '+8.000.000 đ',
        'icon': Icons.attach_money,
        'color': const Color(0xFF28A745),
        'isIncome': true,
      },
      {
        'title': 'Mua sắm',
        'category': 'Mua sắm',
        'date': '31/08/2024',
        'amount': '-300.000 đ',
        'icon': Icons.shopping_cart,
        'color': const Color(0xFFAA43F5),
        'isIncome': false,
      },
      {
        'title': 'Học phí',
        'category': 'Giáo dục',
        'date': '30/08/2024',
        'amount': '-500.000 đ',
        'icon': Icons.school,
        'color': const Color(0xFF159B9B),
        'isIncome': false,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE9EDF2),
        ),
      ),
      child: Column(
        children: List.generate(
          transactions.length,
              (index) {
            final transaction = transactions[index];

            return _buildTransactionItem(
              title: transaction['title'] as String,
              category: transaction['category'] as String,
              date: transaction['date'] as String,
              amount: transaction['amount'] as String,
              icon: transaction['icon'] as IconData,
              color: transaction['color'] as Color,
              isIncome: transaction['isIncome'] as bool,
              showDivider: index != transactions.length - 1,
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // ITEM GIAO DỊCH
  // =========================================================

  Widget _buildTransactionItem({
    required String title,
    required String category,
    required String date,
    required String amount,
    required IconData icon,
    required Color color,
    required bool isIncome,
    required bool showDivider,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),

      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
          bottom: BorderSide(
            color: Color(0xFFEAECEF),
          ),
        )
            : null,
      ),

      child: Row(
        children: [

          // ICON
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 15,
            ),
          ),

          const SizedBox(width: 8),

          // TÊN + DANH MỤC
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [

                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF8993A4),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF8993A4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SỐ TIỀN
          Text(
            amount,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF21A642)
                  : const Color(0xFFFF3947),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 57,

      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE9EDF2),
          ),
        ),
      ),

      child: Row(
        children: [

          _buildNavItem(
            icon: Icons.home,
            title: 'Trang chủ',
            active: true,
          ),

          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            title: 'Giao dịch',
            active: false,
          ),

          _buildNavItem(
            icon: Icons.pie_chart_outline,
            title: 'Thống kê',
            active: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool active,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {},

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 19,
              color: active
                  ? const Color(0xFF2878E8)
                  : const Color(0xFF4D5665),
            ),

            const SizedBox(height: 2),

            Text(
              title,
              style: TextStyle(
                fontSize: 7,
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: active
                    ? const Color(0xFF2878E8)
                    : const Color(0xFF4D5665),
              ),
            ),
          ],
        ),
      ),
    );
  }
}