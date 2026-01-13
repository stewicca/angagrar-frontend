import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/expense/expense.dart';
import '../../domain/entity/expense/expenses.dart';
import '../../domain/repository/expenses_repository.dart';
import '../source/remote/expenses_remote_data_source.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesRemoteDataSource remoteDataSource;

  ExpensesRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<Either<Failure, Expenses>> getExpenses() async {
    try {
      final result = await remoteDataSource.getExpenses();
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
  Future<Either<Failure, Expense>> addExpense({
    required String category,
    String? description,
    required int amount,
  }) async {
    try {
      final result = await remoteDataSource.addExpense(
        category: category,
        description: description,
        amount: amount,
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
