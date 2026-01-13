import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, role, content, createdAt];
}
