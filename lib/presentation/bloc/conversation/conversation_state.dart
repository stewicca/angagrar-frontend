part of 'conversation_bloc.dart';

sealed class ConversationState extends Equatable {
  const ConversationState();
}

class ConversationInitial extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationStarted extends ConversationState {
  final Conversation conversation;

  const ConversationStarted({required this.conversation});

  @override
  List<Object> get props => [conversation];
}

class MessageSending extends ConversationState {
  @override
  List<Object> get props => [];
}

class MessageReceived extends ConversationState {
  final ConversationResponse response;

  const MessageReceived({required this.response});

  @override
  List<Object> get props => [response];
}

class ConversationCompleted extends ConversationState {
  final ConversationResponse response;

  const ConversationCompleted({required this.response});

  @override
  List<Object> get props => [response];
}

class ConversationHistoryLoaded extends ConversationState {
  final ConversationHistory history;

  const ConversationHistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError({required this.message});

  @override
  List<Object> get props => [message];
}
