import 'package:equatable/equatable.dart';
import 'category.dart';

class Categories extends Equatable {
  final int status;
  final String message;
  final List<Category> categories;

  const Categories({
    required this.status,
    required this.message,
    required this.categories,
  });

  @override
  List<Object?> get props => [status, message, categories];
}
