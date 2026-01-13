import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/budget/budget.dart';
import '../../../domain/repository/budgets_repository.dart';

part 'budgets_event.dart';
part 'budgets_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final BudgetsRepository _repository;

  BudgetsBloc(this._repository) : super(BudgetsInitial()) {
    on<FetchBudgets>((event, emit) async {
      emit(BudgetsLoading());

      final result = await _repository.getBudgets();

      result.fold(
        (failure) => emit(BudgetsError(message: failure.message)),
        (budgets) => emit(BudgetsSuccess(budgets: budgets)),
      );
    });

    on<UpdateBudgetAmount>((event, emit) async {
      emit(BudgetsLoading());

      final result = await _repository.updateBudget(
        id: event.budgetId,
        amount: event.newAmount,
      );

      await result.fold(
        (failure) async {
          emit(BudgetsError(message: failure.message));
        },
        (budget) async {
          emit(BudgetUpdateSuccess(updatedBudget: budget));
          // Reload all budgets to get fresh state
          add(const FetchBudgets());
        },
      );
    });
  }
}
