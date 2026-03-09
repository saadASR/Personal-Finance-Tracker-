import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_translations.dart';
import '../../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final settings = ref.watch(settingsProvider);
    final lang = settings.languageCode;
    
    String t(String key) => AppTranslations.get(key, lang);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('settings')),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSection(
            context,
            title: t('appearance'),
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.blue,
                  ),
                ),
                title: Text(t('darkMode')),
                subtitle: Text(isDarkMode ? 'On' : 'Off'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setDarkMode(value);
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: t('preferences'),
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                title: Text(t('currency')),
                subtitle: Text('${settings.currency} ($currencySymbol)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyPicker(context, ref, settings.currency, t),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.teal,
                  ),
                ),
                title: Text(t('language')),
                subtitle: Text(_getLanguageName(settings.languageCode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguagePicker(context, ref, settings.languageCode),
              ),
            ],
          ),
          _buildSection(
            context,
            title: t('about'),
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.purple,
                  ),
                ),
                title: Text(t('version')),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.code,
                    color: Colors.orange,
                  ),
                ),
                title: Text(t('builtWithFlutter')),
                subtitle: const Text('Personal Finance Tracker'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref, String currentCurrency, String Function(String) t) {
    final currencies = [
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
      {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
      {'code': 'CHF', 'symbol': 'CHF', 'name': 'Swiss Franc'},
      {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
      {'code': 'SGD', 'symbol': 'S\$', 'name': 'Singapore Dollar'},
      {'code': 'MAD', 'symbol': 'د.م.', 'name': 'Moroccan Dirham'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Select Currency',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency['code'] == currentCurrency;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          currency['symbol']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppTheme.primaryColor : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    title: Text(currency['name']!),
                    subtitle: Text(currency['code']!),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      ref.read(settingsProvider.notifier).setCurrency(
                            currency['code']!,
                            currency['symbol']!,
                          );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String currentLanguage) {
    final languages = [
      {'code': 'en', 'name': 'English', 'native': 'English'},
      {'code': 'fr', 'name': 'French', 'native': 'Français'},
      {'code': 'ar', 'name': 'Arabic', 'native': 'العربية'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Select Language',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...languages.map((language) {
              final isSelected = language['code'] == currentLanguage;
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      language['code']!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppTheme.primaryColor : Colors.grey,
                      ),
                    ),
                  ),
                ),
                title: Text(language['native']!),
                subtitle: Text(language['name']!),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                    : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setLanguage(language['code']!);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
