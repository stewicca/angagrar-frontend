import 'package:equatable/equatable.dart';
import '../../../domain/entity/category/category.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String label;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.label,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    label: json['label'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'label': label,
  };

  Category toEntity() => Category(
    id: id,
    name: name,
    label: label,
  );

  @override
  List<Object?> get props => [id, name, label];
}
