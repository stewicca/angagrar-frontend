import 'package:equatable/equatable.dart';
import '../../../domain/entity/budget/budget.dart';

class BudgetModel extends Equatable {
  final int id;
  final int userId;
  final String category;
  final int amount;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final DateTime createdAt;

  const BudgetModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.description,
    required this.createdAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    category: json['category'] ?? '',
    amount: json['amount'] ?? 0,
    period: json['period'] ?? 'monthly',
    startDate: json['start_date'] != null
        ? DateTime.parse(json['start_date'])
        : DateTime.now(),
    endDate: json['end_date'] != null
        ? DateTime.parse(json['end_date'])
        : DateTime.now(),
    description: json['description'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'category': category,
    'amount': amount,
    'period': period,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    if (description != null) 'description': description,
    'created_at': createdAt.toIso8601String(),
  };

  Budget toEntity() => Budget(
    id: id,
    userId: userId,
    category: category,
    amount: amount,
    period: period,
    startDate: startDate,
    endDate: endDate,
    description: description,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    category,
    amount,
    period,
    startDate,
    endDate,
    description,
    createdAt,
  ];
}
