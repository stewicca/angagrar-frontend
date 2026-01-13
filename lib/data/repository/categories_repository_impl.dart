import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/category/categories.dart';
import '../../domain/repository/categories_repository.dart';
import '../source/remote/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<Either<Failure, Categories>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
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
