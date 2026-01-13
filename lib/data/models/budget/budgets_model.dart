import 'package:equatable/equatable.dart';
import '../../../domain/entity/budget/budgets.dart';
import 'budget_model.dart';

class BudgetsModel extends Equatable {
  final int status;
  final String message;
  final List<BudgetModel> budgets;

  const BudgetsModel({
    required this.status,
    required this.message,
    required this.budgets,
  });

  factory BudgetsModel.fromJson(Map<String, dynamic> json) => BudgetsModel(
    status: json['status'] ?? 0,
    message: json['message'] ?? '',
    budgets: (json['data'] as List<dynamic>? ?? [])
        .map((e) => BudgetModel.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': budgets.map((e) => e.toJson()).toList(),
  };

  Budgets toEntity() => Budgets(
    status: status,
    message: message,
    budgets: budgets.map((e) => e.toEntity()).toList(),
  );

  @override
  List<Object?> get props => [status, message, budgets];
}
