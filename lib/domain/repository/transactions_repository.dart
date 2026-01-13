import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/transaction/transaction.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, Transaction>> addTransaction({
    required String type,
    required String category,
    required int amount,
    String? description,
    required DateTime date,
  });
}
