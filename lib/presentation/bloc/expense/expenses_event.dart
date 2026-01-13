part of 'expenses_bloc.dart';

sealed class ExpensesEvent extends Equatable {
  const ExpensesEvent();
}

class FetchExpenses extends ExpensesEvent {
  const FetchExpenses();

  @override
  List<Object?> get props => [];
}

class AddExpense extends ExpensesEvent {
  final String category;
  final String? description;
  final int amount;

  const AddExpense({
    required this.category,
    this.description,
    required this.amount,
  });

  @override
  List<Object?> get props => [category, description, amount];
}
