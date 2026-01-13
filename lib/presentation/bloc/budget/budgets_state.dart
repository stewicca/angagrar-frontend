part of 'budgets_bloc.dart';

sealed class BudgetsState extends Equatable {
  const BudgetsState();

  @override
  List<Object> get props => [];
}

class BudgetsInitial extends BudgetsState {}

class BudgetsLoading extends BudgetsState {}

class BudgetsSuccess extends BudgetsState {
  final List<Budget> budgets;

  const BudgetsSuccess({required this.budgets});

  @override
  List<Object> get props => [budgets];
}

class BudgetUpdateSuccess extends BudgetsState {
  final Budget updatedBudget;

  const BudgetUpdateSuccess({required this.updatedBudget});

  @override
  List<Object> get props => [updatedBudget];
}

class BudgetsError extends BudgetsState {
  final String message;

  const BudgetsError({required this.message});

  @override
  List<Object> get props => [message];
}
