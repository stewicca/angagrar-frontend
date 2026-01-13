import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final int? userId;
  final String? guestId;
  final String? token;

  const Auth({this.userId, this.guestId, this.token});

  @override
  List<Object?> get props => [userId, guestId, token];
}
