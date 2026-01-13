import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/transaction/transaction.dart';
import '../../domain/repository/transactions_repository.dart';
import '../source/remote/transactions_remote_data_source.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource remoteDataSource;

  TransactionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final result = await remoteDataSource.getTransactions();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (_) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction({
    required String type,
    required String category,
    required int amount,
    String? description,
    required DateTime date,
  }) async {
    try {
      final result = await remoteDataSource.addTransaction(
        type: type,
        category: category,
        amount: amount,
        description: description,
        date: date,
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
}
