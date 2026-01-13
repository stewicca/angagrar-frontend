import 'package:equatable/equatable.dart';
import '../../../domain/entity/auth/sign_in.dart';

class SignInModel extends Equatable {
  final int status;
  final String message;
  final String? token;

  const SignInModel({ required this.status, required this.message, this.token });

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['data']?['token']
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'token': token
    }
  };

  SignIn toEntity() {
    return SignIn(status: status, message: message, token: token ?? '');
  }

  @override
  List<Object?> get props => [status, message, token];
}
