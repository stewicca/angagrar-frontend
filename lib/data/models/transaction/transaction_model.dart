import 'package:equatable/equatable.dart';
import '../../../domain/entity/transaction/transaction.dart';

class TransactionModel extends Equatable {
  final int id;
  final int userId;
  final String type;
  final String category;
  final int amount;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    required this.date,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        type: json['type'] ?? 'expense',
        category: json['category'] ?? '',
        amount: json['amount'] ?? 0,
        description: json['description'],
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type,
    'category': category,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  Transaction toEntity() => Transaction(
    id: id,
    userId: userId,
    type: type,
    category: category,
    amount: amount,
    description: description,
    date: date,
    createdAt: createdAt,
  );

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
