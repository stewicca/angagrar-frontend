import 'package:equatable/equatable.dart';
import 'package:expensetracker/domain/entity/budget/budget.dart';

class ConversationResponse extends Equatable {
  final String assistantMessage;
  final bool completed;
  final bool? budgetGenerated;
  final List<Budget>? budgets;

  const ConversationResponse({
    required this.assistantMessage,
    required this.completed,
    this.budgetGenerated,
    this.budgets,
  });

  @override
  List<Object?> get props => [
    assistantMessage,
    completed,
    budgetGenerated,
    budgets,
  ];
}
