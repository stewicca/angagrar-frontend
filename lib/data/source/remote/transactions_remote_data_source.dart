import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/transaction/transaction_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<TransactionModel> addTransaction({
    required String type,
    required String category,
    required int amount,
    String? description,
    required DateTime date,
  });
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final Dio dio;

  TransactionsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await dio.get('transactions');
      final data = response.data;

      if (response.statusCode == 200) {
        // Response structure: { transactions: [...] }
        final List transactionsJson = data['transactions'] ?? [];
        return transactionsJson
            .map((json) => TransactionModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(data['message'] ?? 'Get transactions failed');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Get transactions failed',
      );
    }
  }

  @override
  Future<TransactionModel> addTransaction({
    required String type,
    required String category,
    required int amount,
    String? description,
    required DateTime date,
  }) async {
    try {
      // Convert to UTC and format with timezone
      final dateString = date.toUtc().toIso8601String();

      final response = await dio.post(
        'transactions',
        data: {
          'type': type,
          'category': category,
          'amount': amount,
          'description': description,
          'date': dateString,
        },
      );
      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Response structure: { transaction: {...} }
        return TransactionModel.fromJson(data['transaction']);
      } else {
        throw ServerException(data['message'] ?? 'Add transaction failed');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Add transaction failed',
      );
    }
  }
}
