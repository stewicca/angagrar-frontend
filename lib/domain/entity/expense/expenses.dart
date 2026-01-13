import 'package:equatable/equatable.dart';
import 'expense.dart';

class Expenses extends Equatable {
  final int status;
  final String message;
  final List<Expense> expenses;

  const Expenses({
    required this.status,
    required this.message,
    required this.expenses,
  });

  @override
  List<Object?> get props => [status, message, expenses];
}
