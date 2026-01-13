import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/conversation/conversation.dart';
import '../entity/conversation/conversation_history.dart';
import '../entity/conversation/conversation_response.dart';

abstract class ConversationRepository {
  Future<Either<Failure, Conversation>> startConversation();
  Future<Either<Failure, ConversationResponse>> sendMessage({
    required String sessionId,
    required String message,
  });
  Future<Either<Failure, ConversationHistory>> getHistory(String sessionId);
  Future<Either<Failure, Conversation>> resetConversation(String sessionId);
}
