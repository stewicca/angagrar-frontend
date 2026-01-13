import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/budget/budget_model.dart';

abstract class BudgetsRemoteDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel> updateBudget({required int id, required int amount});
}

class BudgetsRemoteDataSourceImpl implements BudgetsRemoteDataSource {
  final Dio dio;

  BudgetsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BudgetModel>> getBudgets() async {
    try {
      final response = await dio.get('budgets');
      final data = response.data;

      if (response.statusCode == 200) {
        // Response structure: { success: true, message: "...", data: { budgets: [...] } }
        final List budgetsJson = data['data']?['budgets'] ?? [];
        return budgetsJson.map((json) => BudgetModel.fromJson(json)).toList();
      } else {
        throw ServerException(data['message'] ?? 'Get budgets failed');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Get budgets failed',
      );
    }
  }

  @override
  Future<BudgetModel> updateBudget({
    required int id,
    required int amount,
  }) async {
    try {
      final response = await dio.patch('budgets/$id', data: {'amount': amount});
      final data = response.data;

      if (response.statusCode == 200) {
        // Response structure: { budget: {...} }
        return BudgetModel.fromJson(data['budget']);
      } else {
        throw ServerException(data['message'] ?? 'Update budget failed');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Update budget failed',
      );
    }
  }
}
