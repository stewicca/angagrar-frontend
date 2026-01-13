import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/conversation/conversation_model.dart';
import '../../models/conversation/conversation_history_model.dart';
import '../../models/conversation/conversation_response_model.dart';

abstract class ConversationRemoteDataSource {
  Future<ConversationModel> startConversation();
  Future<ConversationResponseModel> sendMessage({
    required String sessionId,
    required String message,
  });
  Future<ConversationHistoryModel> getHistory(String sessionId);
  Future<ConversationModel> resetConversation(String sessionId);
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  final Dio dio;

  ConversationRemoteDataSourceImpl({required this.dio});

  @override
  Future<ConversationModel> startConversation() async {
    try {
      final response = await dio.post('conversations/start');
      final data = response.data;
      if (response.statusCode == 200) {
        return ConversationModel.fromJson(data['data']);
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to start conversation',
        );
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Failed to start conversation',
      );
    }
  }

  @override
  Future<ConversationResponseModel> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      final response = await dio.post(
        'conversations/$sessionId/messages',
        data: {'message': message},
      );
      final data = response.data;
      if (response.statusCode == 200) {
        return ConversationResponseModel.fromJson(data['data']);
      } else {
        throw ServerException(data['message'] ?? 'Failed to send message');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Failed to send message',
      );
    }
  }

  @override
  Future<ConversationHistoryModel> getHistory(String sessionId) async {
    try {
      final response = await dio.get('conversations/$sessionId/history');
      final data = response.data;
      if (response.statusCode == 200) {
        return ConversationHistoryModel.fromJson(data['data']);
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to get conversation history',
        );
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Failed to get conversation history',
      );
    }
  }

  @override
  Future<ConversationModel> resetConversation(String sessionId) async {
    try {
      final response = await dio.post('conversations/$sessionId/reset');
      final data = response.data;
      if (response.statusCode == 200) {
        return ConversationModel.fromJson(data['data']);
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to reset conversation',
        );
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Failed to reset conversation',
      );
    }
  }
}
