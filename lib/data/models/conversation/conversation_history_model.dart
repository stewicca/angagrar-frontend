import 'package:equatable/equatable.dart';
import '../../../domain/entity/conversation/conversation_history.dart';
import 'message_model.dart';

class ConversationHistoryModel extends Equatable {
  final List<MessageModel> messages;

  const ConversationHistoryModel({required this.messages});

  factory ConversationHistoryModel.fromJson(Map<String, dynamic> json) {
    final List messagesList = json['messages'] ?? [];
    return ConversationHistoryModel(
      messages: messagesList.map((msg) => MessageModel.fromJson(msg)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'messages': messages.map((msg) => msg.toJson()).toList(),
  };

  ConversationHistory toEntity() => ConversationHistory(
    messages: messages.map((msg) => msg.toEntity()).toList(),
  );

  @override
  List<Object> get props => [messages];
}
