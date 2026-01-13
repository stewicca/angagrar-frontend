import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/entity/budget/budget.dart';
import '../../bloc/budget/budgets_bloc.dart';
import '../home/home_page.dart';

class BudgetResultPage extends StatelessWidget {
  static const String ROUTE_NAME = '/budget_result_page';
  final List<Budget>? initialBudgets;

  const BudgetResultPage({super.key, this.initialBudgets});

  @override
  Widget build(BuildContext context) {
    // If budgets passed from conversation, display them immediately
    if (initialBudgets != null && initialBudgets!.isNotEmpty) {
      return _buildScaffold(context, initialBudgets!);
    }

    // Otherwise fetch from API
    context.read<BudgetsBloc>().add(const FetchBudgets());

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Anggarann Ala Kamu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text('✨', style: TextStyle(fontSize: 20)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
      ),
      body: BlocBuilder<BudgetsBloc, BudgetsState>(
        builder: (context, state) {
          if (state is BudgetsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            );
          }

          if (state is BudgetsSuccess) {
            return _buildBudgetContent(context, state.budgets);
          }

          if (state is BudgetsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, List<Budget> budgets) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Anggarann Ala Malika',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text('✨', style: TextStyle(fontSize: 20)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
      ),
      body: _buildBudgetContent(context, budgets),
    );
  }

  Widget _buildBudgetContent(BuildContext context, List<Budget> budgets) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Budget cards
              ...budgets.asMap().entries.map((entry) {
                final index = entry.key;
                final budget = entry.value;

                // First card is large
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLargeBudgetCard(budget),
                  );
                }

                return const SizedBox.shrink();
              }).toList(),

              // Grid for remaining cards
              if (budgets.length > 1)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: budgets.length - 1,
                  itemBuilder: (context, index) {
                    return _buildBudgetCard(budgets[index + 1]);
                  },
                ),
            ],
          ),
        ),

        // Bottom button
        Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomePage.ROUTE_NAME);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Gas, Pake Anggaran Ini!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeBudgetCard(Budget budget) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(budget.category),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(budget.category),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        budget.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FaIcon(
                      _getCategoryFaIcon(budget.category),
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatAmount(budget.amount)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(budget.category),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Category name with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  budget.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FaIcon(
                _getCategoryFaIcon(budget.category),
                color: Colors.white,
                size: 18,
              ),
            ],
          ),

          // Amount
          Text(
            'Rp ${_formatAmount(budget.amount)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('healing') ||
        lowerCategory.contains('nongkrong')) {
      return [const Color(0xFFEC4899), const Color(0xFF8B5CF6)];
    } else if (lowerCategory.contains('kewajiban')) {
      return [const Color(0xFF9CA3AF), const Color(0xFF6B7280)];
    } else if (lowerCategory.contains('makan')) {
      return [const Color(0xFF14B8A6), const Color(0xFF06B6D4)];
    } else if (lowerCategory.contains('tabungan') ||
        lowerCategory.contains('detuan')) {
      return [const Color(0xFF8B5CF6), const Color(0xFF6366F1)];
    } else if (lowerCategory.contains('transport')) {
      return [const Color(0xFF10B981), const Color(0xFF14B8A6)];
    } else {
      return [const Color(0xFF6B7280), const Color(0xFF4B5563)];
    }
  }

  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('healing') ||
        lowerCategory.contains('nongkrong')) {
      return Icons.self_improvement;
    } else if (lowerCategory.contains('kewajiban')) {
      return Icons.home;
    } else if (lowerCategory.contains('makan')) {
      return Icons.restaurant;
    } else if (lowerCategory.contains('tabungan') ||
        lowerCategory.contains('detuan')) {
      return Icons.savings;
    } else if (lowerCategory.contains('transport')) {
      return Icons.directions_car;
    } else {
      return Icons.category;
    }
  }

  IconData _getCategoryFaIcon(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('healing')) {
      return FontAwesomeIcons.mugHot;
    } else if (lowerCategory.contains('kewajiban')) {
      return FontAwesomeIcons.house;
    } else if (lowerCategory.contains('makan')) {
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

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
