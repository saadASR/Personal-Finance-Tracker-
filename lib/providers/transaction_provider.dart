import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/models.dart';
import '../data/repositories/repositories.dart';

final transactionRepositoryProvider = Provider((ref) => TransactionRepository());

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  return TransactionsNotifier(ref.watch(transactionRepositoryProvider));
});

final selectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final TransactionRepository _repository;
  final _uuid = const Uuid();

  TransactionsNotifier(this._repository) : super([]) {
    loadTransactions();
  }

  void loadTransactions() {
    state = _repository.getAllTransactions();
  }

  List<TransactionModel> getTransactionsByMonth(int month, int year) {
    return _repository.getTransactionsByMonth(month, year);
  }

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String categoryId,
    required DateTime date,
    required TransactionType type,
    String note = '',
  }) async {
    final transaction = TransactionModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
      typeIndex: type.index,
    );
    await _repository.addTransaction(transaction);
    loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.updateTransaction(transaction);
    loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    loadTransactions();
  }

  double getTotalIncome() => _repository.getTotalIncome();
  double getTotalExpenses() => _repository.getTotalExpenses();
  
  double getMonthlyIncome(int month, int year) => 
      _repository.getMonthlyIncome(month, year);
  
  double getMonthlyExpenses(int month, int year) => 
      _repository.getMonthlyExpenses(month, year);

  Map<String, double> getExpensesByCategory(int month, int year) =>
      _repository.getExpensesByCategory(month, year);

  List<double> getDailyBalances(int month, int year) =>
      _repository.getDailyBalances(month, year);
}

final monthlyTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => t.date.month == selectedMonth.month && t.date.year == selectedMonth.year)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

final monthlyIncomeProvider = Provider<double>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => t.typeIndex == 0 && t.date.month == selectedMonth.month && t.date.year == selectedMonth.year)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyExpensesProvider = Provider<double>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => t.typeIndex == 1 && t.date.month == selectedMonth.month && t.date.year == selectedMonth.year)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expenses = ref.watch(monthlyExpensesProvider);
  return income - expenses;
});

final categoryExpensesProvider = Provider<Map<String, double>>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactions = ref.watch(transactionsProvider);
  final Map<String, double> result = {};
  
  for (final t in transactions) {
    if (t.typeIndex == 1 && 
        t.date.month == selectedMonth.month && 
        t.date.year == selectedMonth.year) {
      result[t.categoryId] = (result[t.categoryId] ?? 0) + t.amount;
    }
  }
  return result;
});

final dailyBalancesProvider = Provider<List<double>>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactions = ref.watch(transactionsProvider);
  final daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
  final List<double> balances = [];
  double runningBalance = 0;

  for (int day = 1; day <= daysInMonth; day++) {
    final date = DateTime(selectedMonth.year, selectedMonth.month, day);
    final dayTransactions = transactions.where((t) =>
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
});
