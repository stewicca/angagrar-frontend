import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/expense/expense.dart';
import '../../../domain/entity/expense/expenses.dart';
import '../../../domain/repository/expenses_repository.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final ExpensesRepository _repository;

  ExpensesBloc(this._repository) : super(ExpensesInitial()) {
    on<FetchExpenses>((event, emit) async {
      emit(ExpensesLoading());

      final result = await _repository.getExpenses();

      result.fold(
            (l) => emit(ExpensesError(message: l.message)),
            (r) => emit(ExpensesLoadSuccess(expenses: r)),
      );
    });

    on<AddExpense>((event, emit) async {
      emit(ExpensesLoading());

      final result = await _repository.addExpense(
        category: event.category,
        description: event.description,
        amount: event.amount,
      );

      result.fold(
            (l) => emit(ExpensesError(message: l.message)),
            (r) => emit(ExpenseAddSuccess(expense: r)),
      );
    });
  }
}
