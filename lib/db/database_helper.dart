import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _db;

  // Lấy database; nếu chưa mở thì mở
  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  // Tạo file database và tạo bảng (chỉ chạy lần đầu)
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            note TEXT
          )
        ''');
      },
    );
  }

  // THÊM
  Future<int> insertTransaction(TransactionModel t) async {
    final db = await database;
    final map = t.toMap()..remove('id'); // bỏ id để database tự đánh số
    return db.insert('transactions', map);
  }

  // ĐỌC TẤT CẢ
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'date DESC, id DESC');
    return rows.map((e) => TransactionModel.fromMap(e)).toList();
  }

  // SỬA
  Future<int> updateTransaction(TransactionModel t) async {
    final db = await database;
    return db.update('transactions', t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }

  // XÓA
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}