import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/user/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> updateMonthlySalary(int monthlySalary);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({ required this.dio });

  @override
  Future<UserModel> updateMonthlySalary(int monthlySalary) async {
    try {
      final response = await dio.patch(
        'users/monthly-salary',
        data: {
          'monthly_salary': monthlySalary,
        },
      );

      final data = response.data;

      if (response.statusCode == 200) {
        return UserModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Update monthly salary failed');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Update monthly salary failed',
      );
    }
  }
}
