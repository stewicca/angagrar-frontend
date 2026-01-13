import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/expense/expense_model.dart';
import '../../models/expense/expenses_model.dart';

abstract class ExpensesRemoteDataSource {
  Future<ExpensesModel> getExpenses();
  Future<ExpenseModel> addExpense({
    required String category,
    String? description,
    required int amount,
  });
}

class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  final Dio dio;

  ExpensesRemoteDataSourceImpl({required this.dio});

  @override
  Future<ExpensesModel> getExpenses() async {
    try {
      final response = await dio.get('expenses');
      final data = response.data;
      if (response.statusCode == 200) {
        return ExpensesModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Get expenses failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Get expenses failed');
    }
  }

  @override
  Future<ExpenseModel> addExpense({
    required String category,
    String? description,
    required int amount,
  }) async {
    try {
      final response = await dio.post('expenses', data: {
        'category': category,
        'description': description,
        'amount': amount,
      });
      final data = response.data;
      if (response.statusCode == 200) {
        return ExpenseModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Add expense failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Add expense failed');
    }
  }
}
