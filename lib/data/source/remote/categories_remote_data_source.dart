import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/category/categories_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<CategoriesModel> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final Dio dio;

  CategoriesRemoteDataSourceImpl({ required this.dio });

  @override
  Future<CategoriesModel> getCategories() async {
    try {
      final response = await dio.get('categories');

      final data = response.data;

      if (response.statusCode == 200) {
        return CategoriesModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Get categories failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Get categories failed');
    }
  }
}
