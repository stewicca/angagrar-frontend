import 'package:equatable/equatable.dart';
import '../../../domain/entity/conversation/conversation.dart';

class ConversationModel extends Equatable {
  final String sessionId;
  final String message;
  final bool completed;
  final bool? budgetGenerated;

  const ConversationModel({
    required this.sessionId,
    required this.message,
    required this.completed,
    this.budgetGenerated,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        sessionId: json['session_id'] ?? '',
        message: json['message'] ?? '',
        completed: json['completed'] ?? false,
        budgetGenerated: json['budget_generated'],
      );

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'message': message,
    'completed': completed,
    if (budgetGenerated != null) 'budget_generated': budgetGenerated,
  };

  Conversation toEntity() => Conversation(
    sessionId: sessionId,
    message: message,
    completed: completed,
    budgetGenerated: budgetGenerated,
  );

  @override
  List<Object?> get props => [sessionId, message, completed, budgetGenerated];
}
