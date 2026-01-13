import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int status;
  final String message;
  final String id;
  final String username;
  final int? monthlySalary;
  final int? regionUmr;

  const User({
    required this.status,
    required this.message,
    required this.id,
    required this.username,
    this.monthlySalary,
    this.regionUmr,
  });

  @override
  List<Object?> get props => [status, message, id, username, monthlySalary, regionUmr];
}
