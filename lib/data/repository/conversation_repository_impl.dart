import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/conversation/conversation.dart';
import '../../domain/entity/conversation/conversation_history.dart';
import '../../domain/entity/conversation/conversation_response.dart';
import '../../domain/repository/conversation_repository.dart';
import '../source/remote/conversation_remote_data_source.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;

  ConversationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Conversation>> startConversation() async {
    try {
      final result = await remoteDataSource.startConversation();
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (_) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, ConversationResponse>> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        sessionId: sessionId,
        message: message,
      );
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (_) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, ConversationHistory>> getHistory(
    String sessionId,
  ) async {
    try {
      final result = await remoteDataSource.getHistory(sessionId);
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (_) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Conversation>> resetConversation(
    String sessionId,
  ) async {
    try {
      final result = await remoteDataSource.resetConversation(sessionId);
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (_) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
