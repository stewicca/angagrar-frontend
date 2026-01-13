import 'package:equatable/equatable.dart';
import 'budget.dart';

class Budgets extends Equatable {
  final int status;
  final String message;
  final List<Budget> budgets;

  const Budgets({
    required this.status,
    required this.message,
    required this.budgets,
  });

  @override
  List<Object?> get props => [status, message, budgets];
}
