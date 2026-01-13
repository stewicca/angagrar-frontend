import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/budget/budget.dart';
import '../../domain/repository/budgets_repository.dart';
import '../source/remote/budgets_remote_data_source.dart';

class BudgetsRepositoryImpl implements BudgetsRepository {
  final BudgetsRemoteDataSource remoteDataSource;

  BudgetsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final result = await remoteDataSource.getBudgets();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (error) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget({
    required int id,
    required int amount,
  }) async {
    try {
      final result = await remoteDataSource.updateBudget(
        id: id,
        amount: amount,
      );
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (error) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
