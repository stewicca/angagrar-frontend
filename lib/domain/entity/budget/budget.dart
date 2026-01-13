import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int id;
  final int userId;
  final String category;
  final int amount;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final DateTime createdAt;

  const Budget({
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
