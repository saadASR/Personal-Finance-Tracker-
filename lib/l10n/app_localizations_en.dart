// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Finance Tracker';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get transactions => 'Transactions';

  @override
  String get categories => 'Categories';

  @override
  String get budgets => 'Budgets';

  @override
  String get settings => 'Settings';

  @override
  String get income => 'Income';

  @override
  String get expenses => 'Expenses';

  @override
  String get balance => 'Balance';

  @override
  String get balanceTrend => 'Balance Trend';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get seeAll => 'See All';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get title => 'Title';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get note => 'Note';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get preview => 'Preview';

  @override
  String get noCategories => 'No categories';

  @override
  String get defaultCategory => 'Default category';

  @override
  String get cannotDeleteCategory => 'Cannot delete category in use';

  @override
  String get addBudget => 'Add Budget';

  @override
  String get editBudget => 'Edit Budget';

  @override
  String get budgetLimit => 'Budget Limit';

  @override
  String get alertSettings => 'Alert Settings';

  @override
  String get noBudgets => 'No budgets set';

  @override
  String get remaining => 'remaining';

  @override
  String get overBudget => 'over budget';

  @override
  String get used => 'used';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get currency => 'Currency';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get builtWithFlutter => 'Built with Flutter';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get budgetAlerts => 'Budget Alerts';

  @override
  String get noBudgetAlerts => 'No budget alerts';

  @override
  String alertWhen(int percent) {
    return 'Alert when $percent% of budget is used';
  }

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get arabic => 'Arabic';
}
