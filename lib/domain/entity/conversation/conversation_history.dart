import 'package:equatable/equatable.dart';
import 'message.dart';

class ConversationHistory extends Equatable {
  final List<Message> messages;

  const ConversationHistory({required this.messages});

  @override
  List<Object> get props => [messages];
}
