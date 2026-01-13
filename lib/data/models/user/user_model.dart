import 'package:equatable/equatable.dart';
import '../../../domain/entity/user/user.dart';

class UserModel extends Equatable {
  final int status;
  final String message;
  final String id;
  final String username;
  final int? monthlySalary;
  final int? regionUmr;

  const UserModel({
    required this.status,
    required this.message,
    required this.id,
    required this.username,
    this.monthlySalary,
    this.regionUmr,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      id: json['data']?['id'] ?? '',
      username: json['data']?['username'] ?? '',
      monthlySalary: json['data']?['monthly_salary'],
      regionUmr: json['data']?['region_umr'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'id': id,
      'username': username,
      'monthly_salary': monthlySalary,
      'region_umr': regionUmr,
    }
  };

  User toEntity() => User(
    status: status,
    message: message,
    id: id,
    username: username,
    monthlySalary: monthlySalary,
    regionUmr: regionUmr,
  );

  @override
  List<Object?> get props => [status, message, id, username, monthlySalary, regionUmr];
}
