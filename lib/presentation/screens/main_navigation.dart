import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_translations.dart';
import '../../providers/providers.dart';
import 'dashboard/dashboard_screen.dart';
import 'transactions/transactions_screen.dart';
import 'categories/categories_screen.dart';
import 'budgets/budgets_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    const CategoriesScreen(),
    const BudgetsScreen(),
    const SettingsScreen(),
  ];

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final lang = ref.watch(settingsProvider).languageCode;
    String t(String key) => AppTranslations.get(key, lang);
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _iOSNavigationBar(
        currentIndex: _currentIndex,
        onTap: setIndex,
        isDarkMode: isDarkMode,
        t: t,
      ),
    );
  }
}

class _iOSNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;
  final String Function(String) t;

  const _iOSNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.isDarkMode,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            color: isDarkMode 
                ? Colors.black.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: isDarkMode 
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iOSNavItem(
                  icon: Icons.dashboard_rounded,
                  label: t('dashboard'),
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                  isDarkMode: isDarkMode,
                ),
                _iOSNavItem(
                  icon: Icons.receipt_long_rounded,
                  label: t('transactions'),
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                  isDarkMode: isDarkMode,
                ),
                _iOSNavItem(
                  icon: Icons.add_circle_rounded,
                  label: '',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                  isDarkMode: isDarkMode,
                  isCenter: true,
                ),
                _iOSNavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: t('budgets'),
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                  isDarkMode: isDarkMode,
                ),
                _iOSNavItem(
                  icon: Icons.settings_rounded,
                  label: t('settings'),
                  isSelected: currentIndex == 4,
                  onTap: () => onTap(4),
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _iOSNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;
  final bool isCenter;

  const _iOSNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected 
        ? AppTheme.primaryColor 
        : (isDarkMode ? Colors.grey[500] : Colors.grey[500]);

    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 60,
          height: 50,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
