import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/expense/expense.dart';
import '../entity/expense/expenses.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, Expenses>> getExpenses();
  Future<Either<Failure, Expense>> addExpense({
    required String category,
    String? description,
    required int amount,
  });
}
