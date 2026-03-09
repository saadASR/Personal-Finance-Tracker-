import '../models/models.dart';
import '../datasources/hive_service.dart';

class TransactionRepository {
  final _box = HiveService.transactionsBoxInstance;

  List<TransactionModel> getAllTransactions() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where((t) => t.date.isAfter(start.subtract(const Duration(days: 1))) && 
                      t.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByMonth(int month, int year) {
    return _box.values
        .where((t) => t.date.month == month && t.date.year == year)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByCategory(String categoryId) {
    return _box.values.where((t) => t.categoryId == categoryId).toList();
  }

  TransactionModel? getTransactionById(String id) {
    return _box.get(id);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  double getTotalIncome() {
    return _box.values
        .where((t) => t.typeIndex == 0)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalExpenses() {
    return _box.values
        .where((t) => t.typeIndex == 1)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getMonthlyIncome(int month, int year) {
    return _box.values
        .where((t) => t.typeIndex == 0 && t.date.month == month && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getMonthlyExpenses(int month, int year) {
    return _box.values
        .where((t) => t.typeIndex == 1 && t.date.month == month && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getExpensesByCategory(int month, int year) {
    final Map<String, double> result = {};
    for (final transaction in _box.values) {
      if (transaction.typeIndex == 1 && 
          transaction.date.month == month && 
          transaction.date.year == year) {
        result[transaction.categoryId] = 
            (result[transaction.categoryId] ?? 0) + transaction.amount;
      }
    }
    return result;
  }

  List<double> getDailyBalances(int month, int year) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final List<double> balances = [];
    double runningBalance = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dayTransactions = _box.values.where((t) =>
          t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day);

      for (final t in dayTransactions) {
        if (t.typeIndex == 0) {
          runningBalance += t.amount;
        } else {
          runningBalance -= t.amount;
        }
      }
      balances.add(runningBalance);
    }

    return balances;
  }
}
