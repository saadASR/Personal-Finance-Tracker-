import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/app_translations.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(monthlyTransactionsProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final lang = ref.watch(settingsProvider).languageCode;
    
    String t(String key) => AppTranslations.get(key, lang);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('transactions')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthChanged: (month) {
                ref.read(selectedMonthProvider.notifier).state = month;
              },
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: t('noTransactions'),
                    subtitle: t('addFirst'),
                    action: ElevatedButton.icon(
                      onPressed: () => _showAddTransaction(context),
                      icon: const Icon(Icons.add),
                      label: Text(t('addTransaction')),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionListTile(
                        transaction: transaction,
                        onTap: () => _showEditTransaction(context, transaction),
                        onDelete: () {
                          ref.read(transactionsProvider.notifier).deleteTransaction(transaction.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t('delete')),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ).animate().fadeIn(delay: (index * 50).ms);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransaction(context),
        icon: const Icon(Icons.add),
        label: Text(t('addTransaction')),
      ).animate().scale(delay: 300.ms),
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionScreen(),
    );
  }

  void _showEditTransaction(BuildContext context, TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionScreen(transaction: transaction),
    );
  }
}
