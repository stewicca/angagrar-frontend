part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();
}

class FetchTransactions extends TransactionsEvent {
  const FetchTransactions();

  @override
  List<Object?> get props => [];
}

class AddTransaction extends TransactionsEvent {
  final String type;
  final String category;
  final int amount;
  final String? description;
  final DateTime date;

  const AddTransaction({
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [type, category, amount, description, date];
}
