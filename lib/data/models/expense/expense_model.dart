import 'package:equatable/equatable.dart';
import '../../../domain/entity/expense/expense.dart';

class ExpenseModel extends Equatable {
  final String id;
  final int amount;
  final String? description;
  final DateTime date;
  final String category;

  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['id'] ?? '',
    amount: json['amount'] ?? 0,
    description: json['description'],
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime(0),
    category: json['category'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
    'category': category,
  };

  Expense toEntity() => Expense(
    id: id,
    amount: amount,
    description: description,
    date: date,
    category: category,
  );

  @override
  List<Object?> get props => [id, amount, description, date, category];
}
