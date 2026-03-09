import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

class HiveService {
  static const String transactionsBox = 'transactions';
  static const String categoriesBox = 'categories';
  static const String budgetsBox = 'budgets';
  static const String settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(BudgetModelAdapter());
    Hive.registerAdapter(AppSettingsModelAdapter());

    await Hive.openBox<TransactionModel>(transactionsBox);
    await Hive.openBox<CategoryModel>(categoriesBox);
    await Hive.openBox<BudgetModel>(budgetsBox);
    await Hive.openBox<AppSettingsModel>(settingsBox);

    await _initializeDefaultCategories();
    await _initializeDefaultSettings();
  }

  static Future<void> _initializeDefaultCategories() async {
    final box = Hive.box<CategoryModel>(categoriesBox);
    if (box.isEmpty) {
      final defaultCategories = [
        CategoryModel(
          id: 'income_salary',
          name: 'Salary',
          iconCodePoint: 0xe3af, // Icons.work
          colorValue: 0xFF4CAF50,
          isIncome: true,
          isDefault: true,
        ),
        CategoryModel(
          id: 'income_investment',
          name: 'Investment',
          iconCodePoint: 0xe893, // Icons.trending_up
          colorValue: 0xFF2196F3,
          isIncome: true,
          isDefault: true,
        ),
        CategoryModel(
          id: 'income_other_income',
          name: 'Other Income',
          iconCodePoint: 0xe8d3, // Icons.attach_money
          colorValue: 0xFF9C27B0,
          isIncome: true,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_food',
          name: 'Food & Dining',
          iconCodePoint: 0xe56c, // Icons.restaurant
          colorValue: 0xFFFF5722,
          isIncome: false,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_transport',
          name: 'Transportation',
          iconCodePoint: 0xe531, // Icons.directions_car
          colorValue: 0xFF607D8B,
          isIncome: false,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_shopping',
          name: 'Shopping',
          iconCodePoint: 0xe59c, // Icons.shopping_bag
          colorValue: 0xFFE91E63,
          isIncome: false,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_entertainment',
          name: 'Entertainment',
          iconCodePoint: 0xe40f, // Icons.movie
          colorValue: 0xFF673AB7,
          isIncome: false,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_bills',
          name: 'Bills & Utilities',
          iconCodePoint: 0xe873, // Icons.receipt_long
          colorValue: 0xFF795548,
          isIncome: false,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_health',
          name: 'Healthcare',
          iconCodePoint: 0xe3f3, // Icons.local_hospital
          colorValue: 0xFFF44336,
          isIncome: false,
          isDefault: true,
        ),
        CategoryModel(
          id: 'expense_education',
          name: 'Education',
          iconCodePoint: 0xe80c, // Icons.school
          colorValue: 0xFF00BCD4,
          isIncome: false,
          isDefault: true,
        ),
      ];

      for (final category in defaultCategories) {
        await box.put(category.id, category);
      }
    }
  }

  static Future<void> _initializeDefaultSettings() async {
    final box = Hive.box<AppSettingsModel>(settingsBox);
    if (box.isEmpty) {
      await box.put('settings', const AppSettingsModel());
    }
  }

  static Box<TransactionModel> get transactionsBoxInstance =>
      Hive.box<TransactionModel>(transactionsBox);

  static Box<CategoryModel> get categoriesBoxInstance =>
      Hive.box<CategoryModel>(categoriesBox);

  static Box<BudgetModel> get budgetsBoxInstance =>
      Hive.box<BudgetModel>(budgetsBox);

  static Box<AppSettingsModel> get settingsBoxInstance =>
      Hive.box<AppSettingsModel>(settingsBox);
}
