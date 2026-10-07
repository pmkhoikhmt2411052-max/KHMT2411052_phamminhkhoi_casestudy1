class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;
  final String note;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note = '',
  });

  // Đổi từ "giao dịch" sang dạng để lưu vào database
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'type': type,
    'category': category,
    'date': date,
    'note': note,
  };

  // Đổi từ dữ liệu trong database ngược lại thành "giao dịch"
  factory TransactionModel.fromMap(Map<String, dynamic> m) => TransactionModel(
    id: m['id'] as int?,
    title: m['title'] as String,
    amount: (m['amount'] as num).toDouble(),
    type: m['type'] as String,
    category: m['category'] as String,
    date: m['date'] as String,
    note: (m['note'] ?? '') as String,
  );
}