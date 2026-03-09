import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/models.dart';
import '../data/repositories/repositories.dart';

final categoryRepositoryProvider = Provider((ref) => CategoryRepository());

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<CategoryModel>>((ref) {
  return CategoriesNotifier(ref.watch(categoryRepositoryProvider));
});

class CategoriesNotifier extends StateNotifier<List<CategoryModel>> {
  final CategoryRepository _repository;
  final _uuid = const Uuid();

  CategoriesNotifier(this._repository) : super([]) {
    loadCategories();
  }

  void loadCategories() {
    state = _repository.getAllCategories();
  }

  List<CategoryModel> getIncomeCategories() {
    return state.where((c) => c.isIncome).toList();
  }

  List<CategoryModel> getExpenseCategories() {
    return state.where((c) => !c.isIncome).toList();
  }

  CategoryModel? getCategoryById(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addCategory({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    required bool isIncome,
  }) async {
    final category = CategoryModel(
      id: _uuid.v4(),
      name: name,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      isIncome: isIncome,
    );
    await _repository.addCategory(category);
    loadCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _repository.updateCategory(category);
    loadCategories();
  }

  Future<bool> deleteCategory(String id) async {
    if (_repository.isCategoryInUse(id)) {
      return false;
    }
    await _repository.deleteCategory(id);
    loadCategories();
    return true;
  }
}

final incomeCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  return ref.watch(categoriesProvider).where((c) => c.isIncome).toList();
});

final expenseCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  return ref.watch(categoriesProvider).where((c) => !c.isIncome).toList();
});

final categoryByIdProvider = Provider.family<CategoryModel?, String>((ref, id) {
  try {
    return ref.watch(categoriesProvider).firstWhere((c) => c.id == id);
  } catch (e) {
    return null;
  }
});
