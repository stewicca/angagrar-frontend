import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/user/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> updateMonthlySalary(int monthlySalary);
}
