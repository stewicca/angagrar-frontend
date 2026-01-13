import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/category/categories.dart';
import '../../../domain/repository/categories_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository _repository;

  CategoriesBloc(this._repository) : super(CategoriesInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoriesLoading());

      final result = await _repository.getCategories();

      result.fold(
            (l) => emit(CategoriesError(message: l.message)),
            (r) => emit(CategoriesSuccess(categories: r)),
      );
    });
  }
}
