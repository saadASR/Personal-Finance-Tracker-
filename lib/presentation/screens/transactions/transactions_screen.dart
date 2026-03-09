import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final currencySymbol = ref.watch(currencySymbolProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
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
                    title: 'No transactions yet',
                    subtitle: 'Tap the + button to add your first transaction',
                    action: ElevatedButton.icon(
                      onPressed: () => _showAddTransaction(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Transaction'),
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
                            const SnackBar(
                              content: Text('Transaction deleted'),
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
        label: const Text('Add'),
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
