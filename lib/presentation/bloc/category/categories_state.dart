part of 'categories_bloc.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {
  final Categories categories;

  const CategoriesSuccess({ required this.categories });
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError({ required this.message });
}
