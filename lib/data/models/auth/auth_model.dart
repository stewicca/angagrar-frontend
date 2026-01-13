import 'package:equatable/equatable.dart';
import '../../../domain/entity/auth/auth.dart';

class AuthModel extends Equatable {
  final int? userId;
  final String? guestId;
  final String? token;

  const AuthModel({this.userId, this.guestId, this.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      userId: json['user']?['id'],
      guestId: json['user']?['guest_id'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user': {
      if (userId != null) 'id': userId,
      if (guestId != null) 'guest_id': guestId,
    },
    if (token != null) 'token': token,
  };

  Auth toEntity() {
    return Auth(userId: userId, guestId: guestId, token: token);
  }

  @override
  List<Object?> get props => [userId, guestId, token];
}
