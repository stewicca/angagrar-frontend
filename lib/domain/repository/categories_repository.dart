import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/category/categories.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, Categories>> getCategories();
}
