import 'package:equatable/equatable.dart';
import '../../../domain/entity/category/categories.dart';
import 'category_model.dart';

class CategoriesModel extends Equatable {
  final int status;
  final String message;
  final List<CategoryModel> categories;

  const CategoriesModel({
    required this.status,
    required this.message,
    required this.categories,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    status: json['status'] ?? 0,
    message: json['message'] ?? '',
    categories: (json['data'] as List<dynamic>? ?? [])
        .map((e) => CategoryModel.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': categories.map((e) => e.toJson()).toList(),
  };

  Categories toEntity() => Categories(
    status: status,
    message: message,
    categories: categories.map((e) => e.toEntity()).toList(),
  );

  @override
  List<Object?> get props => [status, message, categories];
}
