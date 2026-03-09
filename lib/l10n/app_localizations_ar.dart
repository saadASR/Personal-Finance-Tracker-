// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متتبع المالية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get transactions => 'المعاملات';

  @override
  String get categories => 'الفئات';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get income => 'الدخل';

  @override
  String get expenses => 'المصروفات';

  @override
  String get balance => 'الرصيد';

  @override
  String get balanceTrend => 'اتجاه الرصيد';

  @override
  String get spendingByCategory => 'الإنفاق حسب الفئة';

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get editTransaction => 'تعديل المعاملة';

  @override
  String get title => 'العنوان';

  @override
  String get amount => 'المبلغ';

  @override
  String get category => 'الفئة';

  @override
  String get date => 'التاريخ';

  @override
  String get note => 'ملاحظة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get noTransactions => 'لا توجد معاملات';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get icon => 'الأيقونة';

  @override
  String get color => 'اللون';

  @override
  String get preview => 'معاينة';

  @override
  String get noCategories => 'لا توجد فئات';

  @override
  String get defaultCategory => 'الفئة الافتراضية';

  @override
  String get cannotDeleteCategory => 'لا يمكن حذف الفئة قيد الاستخدام';

  @override
  String get addBudget => 'إضافة ميزانية';

  @override
  String get editBudget => 'تعديل الميزانية';

  @override
  String get budgetLimit => 'حد الميزانية';

  @override
  String get alertSettings => 'إعدادات التنبيه';

  @override
  String get noBudgets => 'لم يتم تحديد ميزانيات';

  @override
  String get remaining => 'متبقي';

  @override
  String get overBudget => 'تجاوز الميزانية';

  @override
  String get used => 'مستخدم';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get currency => 'العملة';

  @override
  String get language => 'اللغة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get builtWithFlutter => 'مبني بـ Flutter';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get budgetAlerts => 'تنبيهات الميزانية';

  @override
  String get noBudgetAlerts => 'لا توجد تنبيهات';

  @override
  String alertWhen(int percent) {
    return 'تنبيه عند استخدام $percent% من الميزانية';
  }

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';
}
