import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/app_translations.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../screens/main_navigation.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _touchedPieIndex = -1;

  String _t(String key) {
    final lang = ref.read(settingsProvider).languageCode;
    return AppTranslations.get(key, lang);
  }

  List<BudgetAlert> _calculateBudgetAlerts() {
    final selectedMonth = ref.read(selectedMonthProvider);
    final budgets = ref.read(monthlyBudgetsProvider);
    final transactions = ref.read(transactionsProvider);
    
    final Map<String, double> categoryExpenses = {};
    for (final t in transactions) {
      if (t.typeIndex == 1 && 
          t.date.month == selectedMonth.month && 
          t.date.year == selectedMonth.year) {
        categoryExpenses[t.categoryId] = (categoryExpenses[t.categoryId] ?? 0) + t.amount;
      }
    }
    
    final categories = ref.read(categoriesProvider);
    
    final List<BudgetAlert> alerts = [];
    
    for (final budget in budgets) {
      final spent = categoryExpenses[budget.categoryId] ?? 0;
      final percentage = budget.limit > 0 ? spent / budget.limit : 0;
      
      if (budget.alertEnabled && percentage >= budget.alertThreshold) {
        final category = categories.firstWhere(
          (c) => c.id == budget.categoryId,
          orElse: () => CategoryModel(
            id: '',
            name: 'Unknown',
            iconCodePoint: 0xe5d3,
            colorValue: 0xFF9E9E9E,
          ),
        );
        
        alerts.add(BudgetAlert(
          category: category,
          budget: budget,
          spent: spent,
          percentage: percentage.toDouble(),
          isExceeded: percentage >= 1.0,
        ));
      }
    }
    
    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpenses = ref.watch(monthlyExpensesProvider);
    final monthlyBalance = ref.watch(monthlyBalanceProvider);
    final categoryExpenses = ref.watch(categoryExpensesProvider);
    final dailyBalances = ref.watch(dailyBalancesProvider);
    final categories = ref.watch(categoriesProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final transactions = ref.watch(monthlyTransactionsProvider);
    final budgetAlerts = _calculateBudgetAlerts();
    final t = _t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showBudgetAlerts(context, budgetAlerts, currencySymbol),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: MonthSelector(
                  selectedMonth: selectedMonth,
                  onMonthChanged: (month) {
                    ref.read(selectedMonthProvider.notifier).state = month;
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildSummaryCards(monthlyIncome, monthlyExpenses, monthlyBalance, currencySymbol),
              const SizedBox(height: 24),
              _buildBalanceTrendChart(dailyBalances, currencySymbol),
              const SizedBox(height: 24),
              _buildCategoryPieChart(categoryExpenses, categories, currencySymbol),
              const SizedBox(height: 24),
              _buildRecentTransactions(transactions.take(5).toList(), currencySymbol),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double income, double expenses, double balance, String currencySymbol) {
    final t = _t;
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: t('income'),
            value: Formatters.currency(income, symbol: currencySymbol),
            icon: Icons.trending_up,
            color: AppTheme.incomeColor,
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: t('expenses'),
            value: Formatters.currency(expenses, symbol: currencySymbol),
            icon: Icons.trending_down,
            color: AppTheme.expenseColor,
          ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(begin: 0.1),
        ),
      ],
    );
  }

  Widget _buildBalanceTrendChart(List<double> dailyBalances, String currencySymbol) {
    if (dailyBalances.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxY = dailyBalances.reduce((a, b) => a > b ? a : b);
    final minY = dailyBalances.reduce((a, b) => a < b ? a : b);
    final range = maxY - minY;
    final padding = range * 0.1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t('balanceTrend'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: range > 0 ? range / 4 : 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            Formatters.compactCurrency(value, symbol: currencySymbol),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (dailyBalances.length / 4).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt() + 1}',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minY - padding,
                  maxY: maxY + padding,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dailyBalances.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms);
  }

  Widget _buildCategoryPieChart(
      Map<String, double> categoryExpenses, List categories, String currencySymbol) {
    if (categoryExpenses.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('spendingByCategory'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  _t('noExpenses'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    }

    final total = categoryExpenses.values.fold(0.0, (sum, val) => sum + val);
    final sections = <PieChartSectionData>[];

    categoryExpenses.forEach((categoryId, amount) {
      CategoryModel? category;
      try {
        category = categories.firstWhere((c) => c.id == categoryId);
      } catch (e) {
        category = null;
      }
      if (category != null) {
        final index = categoryExpenses.keys.toList().indexOf(categoryId);
        final percentage = (amount / total * 100);
        final isTouched = index == _touchedPieIndex;
        final radius = isTouched ? 70.0 : 60.0;

        sections.add(
          PieChartSectionData(
            color: Color(category.colorValue),
            value: amount,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: isTouched ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t('spendingByCategory'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedPieIndex = -1;
                          return;
                        }
                        _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: categoryExpenses.entries.map((entry) {
                CategoryModel? category;
                try {
                  category = categories.firstWhere((c) => c.id == entry.key);
                } catch (e) {
                  category = null;
                }
                if (category == null) return const SizedBox.shrink();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(category.colorValue),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 300.ms);
  }

  Widget _buildRecentTransactions(List transactions, String currencySymbol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t('recentTransactions'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                final bottomNavState = context.findAncestorStateOfType<MainNavigationState>();
                bottomNavState?.setIndex(1);
              },
              child: Text(_t('seeAll')),
            ),
          ],
        ),
        if (transactions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _t('noTransactions'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return TransactionListTile(
                  transaction: transactions[index],
                  onDelete: () {
                    ref.read(transactionsProvider.notifier).deleteTransaction(transactions[index].id);
                  },
                );
              },
            ),
          ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 400.ms);
  }

  void _showBudgetAlerts(BuildContext context, List<BudgetAlert> alerts, String currencySymbol) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active, color: AppTheme.expenseColor),
                const SizedBox(width: 8),
                Text(
                  _t('budgetAlerts'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (alerts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    _t('noBudgetAlerts'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...alerts.map((alert) => ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: alert.isExceeded
                            ? AppTheme.expenseColor.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        alert.isExceeded ? Icons.warning : Icons.info_outline,
                        color: alert.isExceeded ? AppTheme.expenseColor : Colors.orange,
                      ),
                    ),
                    title: Text(alert.category.name),
                    subtitle: Text(
                      '${Formatters.currency(alert.spent, symbol: currencySymbol)} of ${Formatters.currency(alert.budget.limit, symbol: currencySymbol)}',
                    ),
                    trailing: Text(
                      Formatters.percentage(alert.percentage),
                      style: TextStyle(
                        color: alert.isExceeded ? AppTheme.expenseColor : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
