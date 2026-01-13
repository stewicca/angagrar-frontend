part of 'expenses_bloc.dart';

sealed class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object> get props => [];
}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoadSuccess extends ExpensesState {
  final Expenses expenses;

  const ExpensesLoadSuccess({required this.expenses});
}

class ExpenseAddSuccess extends ExpensesState {
  final Expense expense;

  const ExpenseAddSuccess({required this.expense});
}

class ExpensesError extends ExpensesState {
  final String message;

  const ExpensesError({required this.message});
}
