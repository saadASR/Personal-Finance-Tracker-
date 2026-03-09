import '../models/models.dart';
import '../datasources/hive_service.dart';

class BudgetRepository {
  final _box = HiveService.budgetsBoxInstance;

  List<BudgetModel> getAllBudgets() {
    return _box.values.toList();
  }

  List<BudgetModel> getBudgetsByMonth(int month, int year) {
    return _box.values
        .where((b) => b.month == month && b.year == year)
        .toList();
  }

  BudgetModel? getBudgetById(String id) {
    return _box.get(id);
  }

  BudgetModel? getBudgetByCategory(String categoryId, int month, int year) {
    try {
      return _box.values.firstWhere(
          (b) => b.categoryId == categoryId && b.month == month && b.year == year);
    } catch (e) {
      return null;
    }
  }

  Future<void> addBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteBudgetsByCategory(String categoryId) async {
    final budgetsToDelete = _box.values.where((b) => b.categoryId == categoryId).toList();
    for (final budget in budgetsToDelete) {
      await _box.delete(budget.id);
    }
  }
}
