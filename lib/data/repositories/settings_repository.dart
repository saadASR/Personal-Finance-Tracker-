import '../models/models.dart';
import '../datasources/hive_service.dart';

class SettingsRepository {
  final _box = HiveService.settingsBoxInstance;

  AppSettingsModel getSettings() {
    return _box.get('settings') ?? const AppSettingsModel();
  }

  Future<void> updateSettings(AppSettingsModel settings) async {
    await _box.put('settings', settings);
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final current = getSettings();
    await _box.put('settings', current.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> setCurrency(String currency, String symbol) async {
    final current = getSettings();
    await _box.put('settings', current.copyWith(
      currency: currency,
      currencySymbol: symbol,
    ));
  }

  Future<void> setLanguage(String languageCode) async {
    final current = getSettings();
    await _box.put('settings', current.copyWith(languageCode: languageCode));
  }
}
