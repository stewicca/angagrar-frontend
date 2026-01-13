part of 'budgets_bloc.dart';

sealed class BudgetsEvent extends Equatable {
  const BudgetsEvent();
}

class FetchBudgets extends BudgetsEvent {
  const FetchBudgets();

  @override
  List<Object?> get props => [];
}

class UpdateBudgetAmount extends BudgetsEvent {
  final int budgetId;
  final int newAmount;

  const UpdateBudgetAmount({required this.budgetId, required this.newAmount});

  @override
  List<Object?> get props => [budgetId, newAmount];
}
