import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../bloc/budget/budgets_bloc.dart';
import '../../bloc/transaction/transactions_bloc.dart';
import '../../../domain/entity/budget/budget.dart';
import '../../../domain/entity/transaction/transaction.dart';
import '../transaction/add_transaction_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const ROUTE_NAME = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetsBloc>().add(const FetchBudgets());
    context.read<TransactionsBloc>().add(const FetchTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BudgetsBloc>().add(const FetchBudgets());
          context.read<TransactionsBloc>().add(const FetchTransactions());
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildSafeToSpendCard(),
                    const SizedBox(height: 32),
                    _buildBudgetOverview(),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTransactionBottomSheet(),
          );
        },
        backgroundColor: const Color(0xFFFF6B6B),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSafeToSpendCard() {
    return BlocBuilder<BudgetsBloc, BudgetsState>(
      builder: (context, budgetState) {
        return BlocBuilder<TransactionsBloc, TransactionsState>(
          builder: (context, transactionState) {
            if (budgetState is BudgetsSuccess &&
                transactionState is TransactionsLoadSuccess) {
              final safeToSpend = _calculateSafeToSpend(
                budgetState.budgets,
                transactionState.transactions,
              );
              final dailyBudget = _calculateDailyBudget(budgetState.budgets);
              final spentToday = _calculateTodaySpending(
                transactionState.transactions,
              );
              final percentage = dailyBudget > 0
                  ? (spentToday / dailyBudget).clamp(0.0, 1.0)
                  : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${_formatAmount(safeToSpend)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Safe-to-Spend Hari Ini',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Progress bar
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2E3F),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percentage,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: percentage < 0.8
                                ? const Color(0xFF10B981)
                                : const Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2E3F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white54),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudgetOverview() {
    return BlocBuilder<BudgetsBloc, BudgetsState>(
      builder: (context, state) {
        if (state is BudgetsLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Budget Kamu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(color: Colors.white54),
              ),
            ],
          );
        }

        if (state is BudgetsSuccess) {
          if (state.budgets.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Kamu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2E3F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada budget',
                          style: TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat_page');
                          },
                          child: const Text(
                            'Buat Budget via Chat AI',
                            style: TextStyle(color: Color(0xFF8B5CF6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Budget Kamu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...state.budgets.map((budget) => _buildBudgetCard(budget)),
            ],
          );
        }

        if (state is BudgetsError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Budget Kamu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2E3F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF6B6B)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFFF6B6B),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Color(0xFFFF6B6B)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BudgetsBloc>().add(const FetchBudgets());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        int spent = 0;

        if (state is TransactionsLoadSuccess) {
          final now = DateTime.now();
          spent = state.transactions
              .where(
                (t) =>
                    t.category == budget.category &&
                    t.type == 'expense' &&
                    t.date.year == now.year &&
                    t.date.month == now.month,
              )
              .fold<int>(0, (sum, t) => sum + t.amount);
        }

        final percentage = budget.amount > 0 ? spent / budget.amount : 0.0;
        final remaining = budget.amount - spent;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2E3F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        budget.category,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCategoryIcon(budget.category),
                      color: _getCategoryColor(budget.category),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sisa: Rp ${_formatAmount(remaining)}',
                          style: TextStyle(
                            color: percentage > 0.9
                                ? const Color(0xFFFF6B6B)
                                : Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: TextStyle(
                      color: percentage > 0.9
                          ? const Color(0xFFFF6B6B)
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1B2E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage.clamp(0.0, 1.0),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: percentage > 0.9
                              ? [
                                  const Color(0xFFFF6B6B),
                                  const Color(0xFFFF6B6B),
                                ]
                              : [
                                  _getCategoryColor(budget.category),
                                  _getCategoryColor(
                                    budget.category,
                                  ).withOpacity(0.7),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp ${_formatAmount(spent)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    'Rp ${_formatAmount(budget.amount)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculateSafeToSpend(
    List<Budget> budgets,
    List<Transaction> transactions,
  ) {
    // Hanya hitung dari budget selain Kewajiban dan Tabungan
    final spendableBudgets = budgets.where((b) {
      final lowerCategory = b.category.toLowerCase();
      return !lowerCategory.contains('kewajiban') &&
          !lowerCategory.contains('tabungan') &&
          !lowerCategory.contains('detuan');
    }).toList();

    final totalMonthlyBudget = spendableBudgets.fold<int>(
      0,
      (sum, b) => sum + b.amount,
    );
    final dailyBudget = totalMonthlyBudget ~/ 30;

    final today = DateTime.now();
    final todaySpending = transactions
        .where(
          (t) =>
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day &&
              t.type == 'expense',
        )
        .fold<int>(0, (sum, t) => sum + t.amount);

    return (dailyBudget - todaySpending).clamp(0, dailyBudget * 2);
  }

  int _calculateDailyBudget(List<Budget> budgets) {
    // Hanya hitung dari budget selain Kewajiban dan Tabungan
    final spendableBudgets = budgets.where((b) {
      final lowerCategory = b.category.toLowerCase();
      return !lowerCategory.contains('kewajiban') &&
          !lowerCategory.contains('tabungan') &&
          !lowerCategory.contains('detuan');
    }).toList();

    final totalMonthlyBudget = spendableBudgets.fold<int>(
      0,
      (sum, b) => sum + b.amount,
    );
    return totalMonthlyBudget ~/ 30;
  }

  int _calculateTodaySpending(List<Transaction> transactions) {
    final today = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day &&
              t.type == 'expense',
        )
        .fold<int>(0, (sum, t) => sum + t.amount);
  }

  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('healing') ||
        lowerCategory.contains('nongkrong')) {
      return FontAwesomeIcons.umbrellaBeach;
    } else if (lowerCategory.contains('kewajiban')) {
      return FontAwesomeIcons.house;
    } else if (lowerCategory.contains('makan') ||
        lowerCategory.contains('kopi')) {
      return FontAwesomeIcons.utensils;
    } else if (lowerCategory.contains('tabungan') ||
        lowerCategory.contains('detuan')) {
      return FontAwesomeIcons.piggyBank;
    } else if (lowerCategory.contains('transport')) {
      return FontAwesomeIcons.car;
    } else {
      return FontAwesomeIcons.list;
    }
  }

  Color _getCategoryColor(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('healing') ||
        lowerCategory.contains('nongkrong')) {
      return const Color(0xFFEC4899);
    } else if (lowerCategory.contains('kewajiban')) {
      return const Color(0xFF6B7280);
    } else if (lowerCategory.contains('makan')) {
      return const Color(0xFF14B8A6);
    } else if (lowerCategory.contains('kopi')) {
      return const Color(0xFFFF8A00);
    } else if (lowerCategory.contains('tabungan') ||
        lowerCategory.contains('detuan')) {
      return const Color(0xFF8B5CF6);
    } else if (lowerCategory.contains('transport')) {
      return const Color(0xFF10B981);
    } else {
      return const Color(0xFF9CA3AF);
    }
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
