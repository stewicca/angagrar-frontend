part of 'conversation_bloc.dart';

sealed class ConversationEvent extends Equatable {
  const ConversationEvent();
}

class StartConversation extends ConversationEvent {
  const StartConversation();

  @override
  List<Object?> get props => [];
}

class SendMessage extends ConversationEvent {
  final String sessionId;
  final String message;

  const SendMessage({required this.sessionId, required this.message});

  @override
  List<Object?> get props => [sessionId, message];
}

class LoadConversationHistory extends ConversationEvent {
  final String sessionId;

  const LoadConversationHistory({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class ResetConversation extends ConversationEvent {
  final String sessionId;

  const ResetConversation({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}
