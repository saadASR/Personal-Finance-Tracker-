import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/models.dart';
import '../data/repositories/repositories.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettingsModel>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});

class SettingsNotifier extends StateNotifier<AppSettingsModel> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const AppSettingsModel()) {
    loadSettings();
  }

  void loadSettings() {
    state = _repository.getSettings();
  }

  Future<void> toggleDarkMode() async {
    await _repository.setDarkMode(!state.isDarkMode);
    loadSettings();
  }

  Future<void> setDarkMode(bool value) async {
    await _repository.setDarkMode(value);
    loadSettings();
  }

  Future<void> setCurrency(String currency, String symbol) async {
    await _repository.setCurrency(currency, symbol);
    loadSettings();
  }
}

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isDarkMode;
});

final currencySymbolProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).currencySymbol;
});
