import 'package:equatable/equatable.dart';
import 'package:expensetracker/data/models/budget/budget_model.dart';
import '../../../domain/entity/conversation/conversation_response.dart';

class ConversationResponseModel extends Equatable {
  final String assistantMessage;
  final bool completed;
  final bool? budgetGenerated;
  final List<BudgetModel>? budgets;

  const ConversationResponseModel({
    required this.assistantMessage,
    required this.completed,
    this.budgetGenerated,
    this.budgets,
  });

  factory ConversationResponseModel.fromJson(Map<String, dynamic> json) {
    List<BudgetModel>? budgetsList;

    if (json['budgets'] != null) {
      final List budgetsJson = json['budgets'];
      budgetsList = budgetsJson.map((b) => BudgetModel.fromJson(b)).toList();
    }

    return ConversationResponseModel(
      assistantMessage: json['assistant_message'] ?? '',
      completed: json['completed'] ?? false,
      budgetGenerated: json['budget_generated'],
      budgets: budgetsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'assistant_message': assistantMessage,
    'completed': completed,
    if (budgetGenerated != null) 'budget_generated': budgetGenerated,
    if (budgets != null) 'budgets': budgets!.map((b) => b.toJson()).toList(),
  };

  ConversationResponse toEntity() => ConversationResponse(
    assistantMessage: assistantMessage,
    completed: completed,
    budgetGenerated: budgetGenerated,
    budgets: budgets?.map((b) => b.toEntity()).toList(),
  );

  @override
  List<Object?> get props => [
    assistantMessage,
    completed,
    budgetGenerated,
    budgets,
  ];
}
