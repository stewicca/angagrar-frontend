import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final int amount;
  final String? description;
  final DateTime date;
  final String category;

  const Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  @override
  List<Object?> get props => [id, amount, description, date, category];
}
