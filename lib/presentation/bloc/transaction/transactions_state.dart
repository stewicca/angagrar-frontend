part of 'transactions_bloc.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoadSuccess extends TransactionsState {
  final List<Transaction> transactions;

  const TransactionsLoadSuccess({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionAddSuccess extends TransactionsState {
  final Transaction transaction;

  const TransactionAddSuccess({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError({required this.message});

  @override
  List<Object> get props => [message];
}
