import '../models/models.dart';
import '../datasources/hive_service.dart';

class CategoryRepository {
  final _box = HiveService.categoriesBoxInstance;

  List<CategoryModel> getAllCategories() {
    return _box.values.toList();
  }

  List<CategoryModel> getIncomeCategories() {
    return _box.values.where((c) => c.isIncome).toList();
  }

  List<CategoryModel> getExpenseCategories() {
    return _box.values.where((c) => !c.isIncome).toList();
  }

  CategoryModel? getCategoryById(String id) {
    return _box.get(id);
  }

  Future<void> addCategory(CategoryModel category) async {
    await _box.put(category.id, category);
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _box.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }

  bool isCategoryInUse(String categoryId) {
    final transactionsBox = HiveService.transactionsBoxInstance;
    return transactionsBox.values.any((t) => t.categoryId == categoryId);
  }
}
