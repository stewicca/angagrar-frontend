import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int id;
  final int userId;
  final String type; // "expense" or "income"
  final String category; // Must match budget categories
  final int amount;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    category,
    amount,
    description,
    date,
    createdAt,
  ];
}
