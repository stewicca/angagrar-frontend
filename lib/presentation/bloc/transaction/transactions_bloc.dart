import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/transaction/transaction.dart';
import '../../../domain/repository/transactions_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsRepository _repository;

  TransactionsBloc(this._repository) : super(TransactionsInitial()) {
    on<FetchTransactions>((event, emit) async {
      emit(TransactionsLoading());

      final result = await _repository.getTransactions();

      result.fold(
        (failure) => emit(TransactionsError(message: failure.message)),
        (transactions) =>
            emit(TransactionsLoadSuccess(transactions: transactions)),
      );
    });

    on<AddTransaction>((event, emit) async {
      emit(TransactionsLoading());

      final result = await _repository.addTransaction(
        type: event.type,
        category: event.category,
        amount: event.amount,
        description: event.description,
        date: event.date,
      );

      await result.fold(
        (failure) async {
          emit(TransactionsError(message: failure.message));
        },
        (transaction) async {
          emit(TransactionAddSuccess(transaction: transaction));
          // Reload transactions to get fresh state
          add(const FetchTransactions());
        },
      );
    });
  }
}
