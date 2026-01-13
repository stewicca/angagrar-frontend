import 'package:equatable/equatable.dart';

class SignIn extends Equatable {
  final int status;
  final String message;
  final String? token;

  const SignIn({
    required this.status,
    required this.message,
    this.token
  });

  @override
  List<Object?> get props => [status, message, token];
}
