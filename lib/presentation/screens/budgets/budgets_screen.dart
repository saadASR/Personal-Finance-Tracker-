import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/app_translations.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(budgetSelectedMonthProvider);
    final budgets = ref.watch(monthlyBudgetsProvider);
    final categories = ref.watch(expenseCategoriesProvider);
    final transactions = ref.watch(transactionsProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final lang = ref.watch(settingsProvider).languageCode;
    
    String t(String key) => AppTranslations.get(key, lang);

    final categoryExpenses = <String, double>{};
    for (final t in transactions) {
      if (t.typeIndex == 1 && 
          t.date.month == selectedMonth.month && 
          t.date.year == selectedMonth.year) {
        categoryExpenses[t.categoryId] = (categoryExpenses[t.categoryId] ?? 0) + t.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t('budgets')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthChanged: (month) {
                ref.read(budgetSelectedMonthProvider.notifier).state = month;
              },
            ),
          ),
          Expanded(
            child: budgets.isEmpty
                ? EmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: t('noBudgets'),
                    subtitle: t('addFirst'),
                    action: ElevatedButton.icon(
                      onPressed: () => _showAddBudget(context, categories),
                      icon: const Icon(Icons.add),
                      label: Text(t('addBudget')),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgets[index];
                      final category = categories.firstWhere(
                        (c) => c.id == budget.categoryId,
                        orElse: () => CategoryModel(
                          id: '',
                          name: 'Unknown',
                          iconCodePoint: 0xe5d3,
                          colorValue: 0xFF9E9E9E,
                        ),
                      );
                      final spent = categoryExpenses[budget.categoryId] ?? 0;
                      final percentage = budget.limit > 0 ? spent / budget.limit : 0.0;
                      final remaining = budget.limit - spent;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: InkWell(
                          onTap: () => _showEditBudget(context, budget, categories),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CategoryIcon(
                                      iconCodePoint: category.iconCodePoint,
                                      color: Color(category.colorValue),
                                      size: 40,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category.name,
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                          Text(
                                            '${Formatters.currency(spent, symbol: currencySymbol)} of ${Formatters.currency(budget.limit, symbol: currencySymbol)}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: AppTheme.expenseColor),
                                              SizedBox(width: 8),
                                              Text('Delete', style: TextStyle(color: AppTheme.expenseColor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _showEditBudget(context, budget, categories);
                                        } else if (value == 'delete') {
                                          _deleteBudget(context, ref, budget);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percentage.clamp(0.0, 1.0),
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      percentage >= 1.0
                                          ? AppTheme.expenseColor
                                          : percentage >= 0.8
                                              ? Colors.orange
                                              : AppTheme.incomeColor,
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(percentage * 100).toStringAsFixed(0)}% ${t('used')}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      remaining >= 0
                                          ? '${Formatters.currency(remaining, symbol: currencySymbol)} ${t('remaining')}'
                                          : '${Formatters.currency(-remaining, symbol: currencySymbol)} ${t('overBudget')}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: remaining >= 0 ? null : AppTheme.expenseColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBudget(context, categories),
        icon: const Icon(Icons.add),
        label: Text(t('addBudget')),
      ).animate().scale(delay: 300.ms),
    );
  }

  void _showAddBudget(BuildContext context, List<CategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetScreen(categories: categories),
    );
  }

  void _showEditBudget(BuildContext context, BudgetModel budget, List<CategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetScreen(budget: budget, categories: categories),
    );
  }

  Future<void> _deleteBudget(BuildContext context, WidgetRef ref, BudgetModel budget) async {
    await ref.read(budgetsProvider.notifier).deleteBudget(budget.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTranslations.get('delete', ref.read(settingsProvider).languageCode)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class AddBudgetScreen extends ConsumerStatefulWidget {
  final BudgetModel? budget;
  final List<CategoryModel> categories;

  const AddBudgetScreen({super.key, this.budget, required this.categories});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  
  String? _selectedCategoryId;
  bool _alertEnabled = true;
  double _alertThreshold = 0.8;
  bool _isLoading = false;

  bool get isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _limitController.text = widget.budget!.limit.toString();
      _selectedCategoryId = widget.budget!.categoryId;
      _alertEnabled = widget.budget!.alertEnabled;
      _alertThreshold = widget.budget!.alertThreshold;
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(budgetSelectedMonthProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final lang = ref.watch(settingsProvider).languageCode;
    
    String t(String key) => AppTranslations.get(key, lang);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? t('editBudget') : t('addBudget'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthDisplay(selectedMonth, t),
                    const SizedBox(height: 20),
                    _buildCategorySelector(t),
                    const SizedBox(height: 16),
                    _buildLimitField(currencySymbol, t),
                    const SizedBox(height: 20),
                    _buildAlertSettings(t),
                    const SizedBox(height: 24),
                    _buildSubmitButton(t),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthDisplay(DateTime selectedMonth, String Function(String) t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 12),
          Text(
            '${t('budgetFor')} ${Formatters.monthYear(selectedMonth)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(String Function(String) t) {
    final existingBudgetCategories = ref.watch(monthlyBudgetsProvider)
        .map((b) => b.categoryId)
        .toSet();

    final availableCategories = widget.categories
        .where((c) => isEditing || !existingBudgetCategories.contains(c.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('category'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (availableCategories.isEmpty)
          Text(t('noCategories'))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableCategories.map((category) {
              final isSelected = _selectedCategoryId == category.id;
              return GestureDetector(
                onTap: isEditing ? null : () => setState(() => _selectedCategoryId = category.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(category.colorValue).withValues(alpha: 0.2)
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Color(category.colorValue) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CategoryIcon(
                        iconCodePoint: category.iconCodePoint,
                        color: Color(category.colorValue),
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildLimitField(String currencySymbol, String Function(String) t) {
    return TextFormField(
      controller: _limitController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: t('budgetLimit'),
        hintText: 'Enter budget limit',
        prefixIcon: const Icon(Icons.attach_money),
        prefixText: currencySymbol,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a budget limit';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(value) <= 0) {
          return 'Budget limit must be greater than 0';
        }
        return null;
      },
    );
  }

  Widget _buildAlertSettings(String Function(String) t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('alertSettings'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Switch(
                  value: _alertEnabled,
                  onChanged: (value) => setState(() => _alertEnabled = value),
                ),
              ],
            ),
            if (_alertEnabled) ...[
              const SizedBox(height: 8),
              Text(
                '${t('alertWhen')} ${(_alertThreshold * 100).toInt()}% ${t('ofBudgetUsed')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Slider(
                value: _alertThreshold,
                min: 0.5,
                max: 1.0,
                divisions: 10,
                label: '${(_alertThreshold * 100).toInt()}%',
                onChanged: (value) => setState(() => _alertThreshold = value),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(String Function(String) t) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(isEditing ? t('save') : t('addBudget')),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTranslations.get('category', ref.read(settingsProvider).languageCode)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final selectedMonth = ref.read(budgetSelectedMonthProvider);

      if (isEditing) {
        final updated = widget.budget!.copyWith(
          limit: double.parse(_limitController.text),
          alertEnabled: _alertEnabled,
          alertThreshold: _alertThreshold,
        );
        await ref.read(budgetsProvider.notifier).updateBudget(updated);
      } else {
        await ref.read(budgetsProvider.notifier).addBudget(
              categoryId: _selectedCategoryId!,
              limit: double.parse(_limitController.text),
              month: selectedMonth.month,
              year: selectedMonth.year,
              alertEnabled: _alertEnabled,
              alertThreshold: _alertThreshold,
            );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? AppTranslations.get('save', ref.read(settingsProvider).languageCode) : AppTranslations.get('addBudget', ref.read(settingsProvider).languageCode)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.expenseColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
