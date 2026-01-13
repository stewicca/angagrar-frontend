import 'package:equatable/equatable.dart';
import '../../../domain/entity/expense/expenses.dart';
import 'expense_model.dart';

class ExpensesModel extends Equatable {
  final int status;
  final String message;
  final List<ExpenseModel> expenses;

  const ExpensesModel({
    required this.status,
    required this.message,
    required this.expenses,
  });

  factory ExpensesModel.fromJson(Map<String, dynamic> json) => ExpensesModel(
    status: json['status'] ?? 0,
    message: json['message'] ?? '',
    expenses: (json['data'] as List<dynamic>? ?? [])
        .map((e) => ExpenseModel.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': expenses.map((e) => e.toJson()).toList(),
  };

  Expenses toEntity() => Expenses(
    status: status,
    message: message,
    expenses: expenses.map((e) => e.toEntity()).toList(),
  );

  @override
  List<Object?> get props => [status, message, expenses];
}
