import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/budget/budget.dart';

abstract class BudgetsRepository {
  Future<Either<Failure, List<Budget>>> getBudgets();
  Future<Either<Failure, Budget>> updateBudget({
    required int id,
    required int amount,
  });
}
