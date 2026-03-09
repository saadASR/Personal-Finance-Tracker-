import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/models.dart';
import '../data/repositories/repositories.dart';

final budgetRepositoryProvider = Provider((ref) => BudgetRepository());

final budgetsProvider = StateNotifierProvider<BudgetsNotifier, List<BudgetModel>>((ref) {
  return BudgetsNotifier(ref.watch(budgetRepositoryProvider));
});

class BudgetsNotifier extends StateNotifier<List<BudgetModel>> {
  final BudgetRepository _repository;
  final _uuid = const Uuid();

  BudgetsNotifier(this._repository) : super([]) {
    loadBudgets();
  }

  void loadBudgets() {
    state = _repository.getAllBudgets();
  }

  List<BudgetModel> getBudgetsByMonth(int month, int year) {
    return _repository.getBudgetsByMonth(month, year);
  }

  BudgetModel? getBudgetByCategory(String categoryId, int month, int year) {
    return _repository.getBudgetByCategory(categoryId, month, year);
  }

  Future<void> addBudget({
    required String categoryId,
    required double limit,
    required int month,
    required int year,
    bool alertEnabled = true,
    double alertThreshold = 0.8,
  }) async {
    final budget = BudgetModel(
      id: _uuid.v4(),
      categoryId: categoryId,
      limit: limit,
      month: month,
      year: year,
      alertEnabled: alertEnabled,
      alertThreshold: alertThreshold,
    );
    await _repository.addBudget(budget);
    loadBudgets();
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _repository.updateBudget(budget);
    loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    loadBudgets();
  }

  Future<void> deleteBudgetsByCategory(String categoryId) async {
    await _repository.deleteBudgetsByCategory(categoryId);
    loadBudgets();
  }
}

final budgetSelectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

final monthlyBudgetsProvider = Provider<List<BudgetModel>>((ref) {
  final selectedMonth = ref.watch(budgetSelectedMonthProvider);
  return ref.watch(budgetsProvider)
      .where((b) => b.month == selectedMonth.month && b.year == selectedMonth.year)
      .toList();
});

class BudgetAlert {
  final CategoryModel category;
  final BudgetModel budget;
  final double spent;
  final double percentage;
  final bool isExceeded;

  BudgetAlert({
    required this.category,
    required this.budget,
    required this.spent,
    required this.percentage,
    required this.isExceeded,
  });
}
