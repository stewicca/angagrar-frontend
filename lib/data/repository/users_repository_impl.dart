import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/repository/users_repository.dart';
import '../source/remote/users_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<Either<Failure, User>> updateMonthlySalary(int monthlySalary) async {
    try {
      final result = await remoteDataSource.updateMonthlySalary(monthlySalary);
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
