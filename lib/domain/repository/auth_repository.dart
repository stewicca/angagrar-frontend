import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/auth/auth.dart';
import '../entity/user/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Auth>> createGuestUser();

  Future<Either<Failure, User>> me();
}
