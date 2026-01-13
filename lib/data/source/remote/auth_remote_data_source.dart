import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/user/user_model.dart';
import '../../models/auth/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> createGuestUser();
  Future<UserModel> me();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> createGuestUser() async {
    try {
      final response = await dio.post('auth/guest');
      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Response structure: { token, user: { id, guest_id, ... } }
        return AuthModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Guest authentication failed');
      }
    } on DioException catch (error) {
      throw ServerException(
        error.response?.data['message'] ?? 'Guest authentication failed',
      );
    }
  }

  @override
  Future<UserModel> me() async {
    try {
      final response = await dio.get('auth/me');

      final data = response.data;

      if (response.statusCode == 200) {
        return UserModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Get me failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Get me failed');
    }
  }
}
