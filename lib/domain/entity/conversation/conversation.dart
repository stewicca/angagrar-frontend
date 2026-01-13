import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String sessionId;
  final String message;
  final bool completed;
  final bool? budgetGenerated;

  const Conversation({
    required this.sessionId,
    required this.message,
    required this.completed,
    this.budgetGenerated,
  });

  @override
  List<Object?> get props => [sessionId, message, completed, budgetGenerated];
}
