part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();
}

class FetchCategories extends CategoriesEvent {
  const FetchCategories();

  @override
  List<Object?> get props => [];
}
